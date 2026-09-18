use zbus::{Connection, proxy, zvariant::OwnedObjectPath};

#[derive(Debug, thiserror::Error)]
pub enum Error {
    #[error("The connection is not active.")]
    InactiveConnection,
    #[error("Device doesn't exist")]
    DeviceNotFound,
    #[error("Failed to communicate with NetworkManager: {0}")]
    Zbus(#[from] zbus::Error),
}

#[proxy(
    interface = "org.freedesktop.NetworkManager",
    default_service = "org.freedesktop.NetworkManager",
    default_path = "/org/freedesktop/NetworkManager"
)]
trait NetworkManager {
    #[zbus(property)]
    fn primary_connection(&self) -> zbus::Result<OwnedObjectPath>;
}

#[proxy(
    interface = "org.freedesktop.NetworkManager.Connection.Active",
    default_service = "org.freedesktop.NetworkManager"
)]
trait ActiveConnection {
    #[zbus(property)]
    fn id(&self) -> zbus::Result<String>;

    #[zbus(
        property,
        name = "Type"
    )]
    fn type_(&self) -> zbus::Result<String>;

    #[zbus(property)]
    fn devices(&self) -> zbus::Result<Vec<OwnedObjectPath>>;
}

#[proxy(
    interface = "org.freedesktop.NetworkManager.Device",
    default_service = "org.freedesktop.NetworkManager"
)]
trait Device {
    #[zbus(property)]
    fn interface(&self) -> zbus::Result<String>;
}

pub async fn get() -> Result<String, Error> {
    let conn = Connection::system().await?;

    let nm_conn = NetworkManagerProxy::new(&conn).await?.primary_connection().await?;

    if nm_conn.as_str() == "/" {
        return Err(Error::InactiveConnection);
    }

    if let Some(device_path) =
        ActiveConnectionProxy::builder(&conn).path(nm_conn)?.build().await?.devices().await?.first()
    {
        Ok(DeviceProxy::builder(&conn).path(device_path)?.build().await?.interface().await?)
    } else {
        Err(Error::DeviceNotFound)
    }
}
