use std::ops::{Deref, DerefMut};

use duckduckgo::{
    browser::Browser,
    params::{SafeSearch, SearchParams, Toggle},
};
use reqwest::Url;
use serde::Deserialize;

use crate::qml_interface::duckduckgo::QmlDuckDuckGo;

const DUCKDUCKGO: &str = "https://duckduckgo.com";

#[derive(Default, PartialEq)]
pub struct DuckDuckGoContent {
    title: String,
    description_html: String,
    image: Option<Url>,
}

impl From<DuckDuckGoContent> for QmlDuckDuckGo {
    fn from(value: DuckDuckGoContent) -> Self {
        Self {
            title: value.title.into(),
            description_html: value.description_html.into(),
            image: value.image.map(|u| u.to_string().into()).unwrap_or_default(),
        }
    }
}

#[derive(Debug, Deserialize)]
pub struct Infobox {
    pub content: Vec<InfoboxContent>,
}

impl Deref for Infobox {
    type Target = Vec<InfoboxContent>;

    fn deref(&self) -> &Self::Target {
        &self.content
    }
}

impl DerefMut for Infobox {
    fn deref_mut(&mut self) -> &mut Self::Target {
        &mut self.content
    }
}

#[derive(Debug, Deserialize)]
pub struct InfoboxContent {
    pub data_type: String,
    pub label: String,
    pub value: InfoboxValue,
    pub wiki_order: String, // Kept as String since the JSON had "101" in quotes
}

#[derive(Debug, Deserialize)]
#[serde(untagged)]
pub enum InfoboxValue {
    Entity(EntityValue),
    String(String),
}

#[derive(Debug, Deserialize)]
pub struct EntityValue {
    #[serde(rename = "entity-type")]
    pub entity_type: String,
    pub id: String,
    #[serde(rename = "numeric-id")]
    pub numeric_id: u32,
}

pub async fn query(input: &str) -> anyhow::Result<DuckDuckGoContent> {
    let resp = Browser::new()
        .get_api_response(
            input,
            Some(&SearchParams::new().safe_search(SafeSearch::Off).full_urls(Toggle::On)),
        )
        .await?;

    let infobox = match resp.info_box.map(serde_json::from_value::<Infobox>) {
        Some(Ok(o)) => Some(o),
        _ => None,
    };

    let alt_desc = resp.entity.unwrap_or(
        match infobox {
            Some(i) => i
                .iter()
                .find(|i| i.data_type == "wd_description" || i.data_type == "official_website")
                .map_or(
                    String::new(),
                    |i| {
                        if i.data_type == "official_website" {
                            i.label.clone()
                        } else {
                            match i.value {
                                InfoboxValue::Entity(_) => unreachable!(),
                                InfoboxValue::String(ref s) => s.to_string(),
                            }
                        }
                    },
                ),
            // TODO: find better way to get title from infobox
            None => String::new(),
        },
    );

    Ok(
        DuckDuckGoContent {
            title: resp
                .heading
                .filter(|h| !h.is_empty())
                .unwrap_or(resp.definition.filter(|d| !d.is_empty()).unwrap_or(alt_desc.clone())),
            description_html: resp
                .answer
                .filter(|a| !a.is_empty())
                .unwrap_or(resp.r#abstract.filter(|a| !a.is_empty()).unwrap_or(alt_desc)),
            // TODO: try also Results[*].Icon.URL and RelatedTopics[*].Icon.URL
            image: resp.image.filter(|i| !i.is_empty()).and_then(
                |i| {
                    if !i.is_empty() {
                        Url::parse(&format!("{DUCKDUCKGO}{i}",)).ok()
                    } else {
                        None
                    }
                },
            ),
        },
    )
}
