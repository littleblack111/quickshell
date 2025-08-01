pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root
    readonly property string time: {
        // fuck you qt give me my 12 hr time
        var h = clock.date.getHours();
        var m = clock.date.getMinutes();
        var s = clock.date.getSeconds();
        h = h % 12;
        if (h === 0)
            h = 12;
        return (h < 10 ? "0" : "") + h + ":" + (m < 10 ? "0" : "") + m + ":" + (s < 10 ? "0" : "") + s;
    }
    readonly property int hours: {
        var h = clock.date.getHours();
        h = h % 12;
        if (h === 0)
            h = 12;
        return h;
    }
    readonly property int minutes: clock.date.getMinutes()
    readonly property int seconds: clock.date.getSeconds()
    readonly property var clock: clock

    readonly property string date: Qt.formatDateTime(clock.date, "dddd dd/MM")

    property var tzData: [
        {
            zone: "Africa/Abidjan",
            names: ["CI", "Ivory Coast", "Abidjan", "GMT", "Greenwich Mean Time"]
        },
        {
            zone: "Africa/Accra",
            names: ["GH", "Ghana", "Accra"]
        },
        {
            zone: "Africa/Addis_Ababa",
            names: ["ET", "Ethiopia", "Addis Ababa", "EAT", "East Africa Time"]
        },
        {
            zone: "Africa/Algiers",
            names: ["DZ", "Algeria", "Algiers", "CET", "Central European Time"]
        },
        {
            zone: "Africa/Asmara",
            names: ["ER", "Eritrea", "Asmara"]
        },
        {
            zone: "Africa/Bamako",
            names: ["ML", "Mali", "Bamako"]
        },
        {
            zone: "Africa/Bangui",
            names: ["CF", "Central African Republic", "Bangui", "WAT", "West Africa Time"]
        },
        {
            zone: "Africa/Banjul",
            names: ["GM", "Gambia", "Banjul"]
        },
        {
            zone: "Africa/Bissau",
            names: ["GW", "Guinea-Bissau", "Bissau"]
        },
        {
            zone: "Africa/Blantyre",
            names: ["MW", "Malawi", "Lilongwe", "CAT", "Central Africa Time"]
        },
        {
            zone: "Africa/Brazzaville",
            names: ["CG", "Congo", "Brazzaville"]
        },
        {
            zone: "Africa/Cairo",
            names: ["EG", "Egypt", "Cairo", "EET", "Eastern European Time"]
        },
        {
            zone: "Africa/Casablanca",
            names: ["MA", "Morocco", "Rabat", "WET", "Western European Time"]
        },
        {
            zone: "Africa/Conakry",
            names: ["GN", "Guinea", "Conakry"]
        },
        {
            zone: "Africa/Dakar",
            names: ["SN", "Senegal", "Dakar"]
        },
        {
            zone: "Africa/Dar_es_Salaam",
            names: ["TZ", "Tanzania", "Dodoma"]
        },
        {
            zone: "Africa/Djibouti",
            names: ["DJ", "Djibouti"]
        },
        {
            zone: "Africa/Douala",
            names: ["CM", "Cameroon", "Yaoundé"]
        },
        {
            zone: "Africa/El_Aaiun",
            names: ["EH", "Western Sahara", "El Aaiún"]
        },
        {
            zone: "Africa/Freetown",
            names: ["SL", "Sierra Leone", "Freetown"]
        },
        {
            zone: "Africa/Gaborone",
            names: ["BW", "Botswana", "Gaborone"]
        },
        {
            zone: "Africa/Harare",
            names: ["ZW", "Zimbabwe", "Harare"]
        },
        {
            zone: "Africa/Johannesburg",
            names: ["ZA", "South Africa", "Pretoria", "SAST", "South Africa Standard Time"]
        },
        {
            zone: "Africa/Juba",
            names: ["SS", "South Sudan", "Juba"]
        },
        {
            zone: "Africa/Kampala",
            names: ["UG", "Uganda", "Kampala"]
        },
        {
            zone: "Africa/Khartoum",
            names: ["SD", "Sudan", "Khartoum"]
        },
        {
            zone: "Africa/Kigali",
            names: ["RW", "Rwanda", "Kigali"]
        },
        {
            zone: "Africa/Kinshasa",
            names: ["CD", "DR Congo", "Kinshasa"]
        },
        {
            zone: "Africa/Lagos",
            names: ["NG", "Nigeria", "Abuja"]
        },
        {
            zone: "Africa/Libreville",
            names: ["GA", "Gabon", "Libreville"]
        },
        {
            zone: "Africa/Lome",
            names: ["TG", "Togo", "Lomé"]
        },
        {
            zone: "Africa/Luanda",
            names: ["AO", "Angola", "Luanda"]
        },
        {
            zone: "Africa/Lubumbashi",
            names: []
        },
        {
            zone: "Africa/Lusaka",
            names: ["ZM", "Zambia", "Lusaka"]
        },
        {
            zone: "Africa/Malabo",
            names: ["GQ", "Equatorial Guinea", "Malabo"]
        },
        {
            zone: "Africa/Maputo",
            names: ["MZ", "Mozambique", "Maputo"]
        },
        {
            zone: "Africa/Maseru",
            names: ["LS", "Lesotho", "Maseru"]
        },
        {
            zone: "Africa/Mbabane",
            names: ["SZ", "Eswatini", "Mbabane"]
        },
        {
            zone: "Africa/Mogadishu",
            names: ["SO", "Somalia", "Mogadishu"]
        },
        {
            zone: "Africa/Monrovia",
            names: ["LR", "Liberia", "Monrovia"]
        },
        {
            zone: "Africa/Nairobi",
            names: ["KE", "Kenya", "Nairobi"]
        },
        {
            zone: "Africa/Ndjamena",
            names: ["TD", "Chad", "N'Djamena"]
        },
        {
            zone: "Africa/Niamey",
            names: ["NE", "Niger", "Niamey"]
        },
        {
            zone: "Africa/Nouakchott",
            names: ["MR", "Mauritania", "Nouakchott"]
        },
        {
            zone: "Africa/Ouagadougou",
            names: ["BF", "Burkina Faso", "Ouagadougou"]
        },
        {
            zone: "Africa/Porto-Novo",
            names: ["BJ", "Benin", "Porto-Novo"]
        },
        {
            zone: "Africa/Sao_Tome",
            names: ["ST", "São Tomé and Príncipe", "São Tomé"]
        },
        {
            zone: "Africa/Tripoli",
            names: ["LY", "Libya", "Tripoli"]
        },
        {
            zone: "Africa/Tunis",
            names: ["TN", "Tunisia", "Tunis"]
        },
        {
            zone: "Africa/Windhoek",
            names: ["NA", "Namibia", "Windhoek"]
        },
        {
            zone: "America/Adak",
            names: ["US", "United States", "Adak", "HST", "Hawaii-Aleutian Standard Time"]
        },
        {
            zone: "America/Anchorage",
            names: ["AKST", "Alaska Standard Time"]
        },
        {
            zone: "America/Araguaina",
            names: ["BR", "Brazil", "Brasília", "BRT", "Brasília Time"]
        },
        {
            zone: "America/Argentina/Buenos_Aires",
            names: ["AR", "Argentina", "Buenos Aires", "ART", "Argentina Time"]
        },
        {
            zone: "America/Asuncion",
            names: ["PY", "Paraguay", "Asunción", "PYT", "Paraguay Time"]
        },
        {
            zone: "America/Atikokan",
            names: ["CA", "Canada", "Ottawa", "EST", "Eastern Standard Time"]
        },
        {
            zone: "America/Bahia",
            names: ["Bahia"]
        },
        {
            zone: "America/Bahia_Banderas",
            names: ["MX", "Mexico", "Mexico City"]
        },
        {
            zone: "America/Barbados",
            names: ["BB", "Barbados", "Bridgetown", "AST", "Atlantic Standard Time"]
        },
        {
            zone: "America/Belem",
            names: ["Belem"]
        },
        {
            zone: "America/Belize",
            names: ["BZ", "Belize", "Belmopan"]
        },
        {
            zone: "America/Boa_Vista",
            names: ["Boa Vista"]
        },
        {
            zone: "America/Bogota",
            names: ["CO", "Colombia", "Bogotá", "COT", "Colombia Time"]
        },
        {
            zone: "America/Boise",
            names: ["Boise", "MST", "Mountain Standard Time"]
        },
        {
            zone: "America/Cambridge_Bay",
            names: ["Cambridge Bay"]
        },
        {
            zone: "America/Campo_Grande",
            names: ["Campo Grande"]
        },
        {
            zone: "America/Cancun",
            names: ["Cancun"]
        },
        {
            zone: "America/Caracas",
            names: ["VE", "Venezuela", "Caracas", "VET", "Venezuela Time"]
        },
        {
            zone: "America/Cayenne",
            names: ["GF", "French Guiana", "Cayenne", "GFT", "French Guiana Time"]
        },
        {
            zone: "America/Cayman",
            names: ["KY", "Cayman Islands", "George Town"]
        },
        {
            zone: "America/Chicago",
            names: ["Chicago", "CST", "Central Standard Time"]
        },
        {
            zone: "America/Chihuahua",
            names: ["Chihuahua"]
        },
        {
            zone: "America/Costa_Rica",
            names: ["CR", "Costa Rica", "San José"]
        },
        {
            zone: "America/Cuiaba",
            names: ["Cuiaba"]
        },
        {
            zone: "America/Curacao",
            names: ["CW", "Curaçao", "Willemstad"]
        },
        {
            zone: "America/Danmarkshavn",
            names: ["GL", "Greenland", "Nuuk"]
        },
        {
            zone: "America/Dawson",
            names: ["Dawson"]
        },
        {
            zone: "America/Dawson_Creek",
            names: ["Dawson Creek"]
        },
        {
            zone: "America/Denver",
            names: ["Denver"]
        },
        {
            zone: "America/Detroit",
            names: ["Detroit"]
        },
        {
            zone: "America/Dominica",
            names: ["DM", "Dominica", "Roseau"]
        },
        {
            zone: "America/Edmonton",
            names: ["Edmonton"]
        },
        {
            zone: "America/El_Salvador",
            names: ["SV", "El Salvador", "San Salvador"]
        },
        {
            zone: "America/Fort_Nelson",
            names: ["Fort Nelson"]
        },
        {
            zone: "America/Fortaleza",
            names: ["Fortaleza"]
        },
        {
            zone: "America/Glace_Bay",
            names: ["Glace Bay"]
        },
        {
            zone: "America/Godthab",
            names: ["Godthab"]
        },
        {
            zone: "America/Goose_Bay",
            names: ["Goose Bay"]
        },
        {
            zone: "America/Grand_Turk",
            names: ["TC", "Turks and Caicos Islands", "Cockburn Town"]
        },
        {
            zone: "America/Grenada",
            names: ["GD", "Grenada", "St. George's"]
        },
        {
            zone: "America/Guadeloupe",
            names: ["GP", "Guadeloupe", "Basse-Terre"]
        },
        {
            zone: "America/Guatemala",
            names: ["GT", "Guatemala", "Guatemala City"]
        },
        {
            zone: "America/Guayaquil",
            names: ["EC", "Ecuador", "Quito", "ECT", "Ecuador Time"]
        },
        {
            zone: "America/Guyana",
            names: ["GY", "Guyana", "Georgetown", "GYT", "Guyana Time"]
        },
        {
            zone: "America/Halifax",
            names: ["Halifax"]
        },
        {
            zone: "America/Havana",
            names: ["CU", "Cuba", "Havana", "CST", "Cuba Standard Time"]
        },
        {
            zone: "America/Hermosillo",
            names: ["Hermosillo"]
        },
        {
            zone: "America/Indiana/Indianapolis",
            names: ["Indianapolis"]
        },
        {
            zone: "America/Indiana/Knox",
            names: ["Knox"]
        },
        {
            zone: "America/Indiana/Marengo",
            names: ["Marengo"]
        },
        {
            zone: "America/Indiana/Petersburg",
            names: ["Petersburg"]
        },
        {
            zone: "America/Indiana/Tell_City",
            names: ["Tell City"]
        },
        {
            zone: "America/Indiana/Vevay",
            names: ["Vevay"]
        },
        {
            zone: "America/Indiana/Vincennes",
            names: ["Vincennes"]
        },
        {
            zone: "America/Indiana/Winamac",
            names: ["Winamac"]
        },
        {
            zone: "America/Inuvik",
            names: ["Inuvik"]
        },
        {
            zone: "America/Iqaluit",
            names: ["Iqaluit"]
        },
        {
            zone: "America/Jamaica",
            names: ["JM", "Jamaica", "Kingston"]
        },
        {
            zone: "America/Juneau",
            names: ["Juneau"]
        },
        {
            zone: "America/Kentucky/Louisville",
            names: ["Louisville"]
        },
        {
            zone: "America/Kentucky/Monticello",
            names: ["Monticello"]
        },
        {
            zone: "America/La_Paz",
            names: ["BO", "Bolivia", "La Paz", "BOT", "Bolivia Time"]
        },
        {
            zone: "America/Lima",
            names: ["PE", "Peru", "Lima", "PET", "Peru Time"]
        },
        {
            zone: "America/Los_Angeles",
            names: ["Los Angeles", "PST", "Pacific Standard Time"]
        },
        {
            zone: "America/Managua",
            names: ["NI", "Nicaragua", "Managua"]
        },
        {
            zone: "America/Manaus",
            names: ["Manaus"]
        },
        {
            zone: "America/Martinique",
            names: ["MQ", "Martinique", "Fort-de-France"]
        },
        {
            zone: "America/Matamoros",
            names: ["Matamoros"]
        },
        {
            zone: "America/Mazatlan",
            names: ["Mazatlan"]
        },
        {
            zone: "America/Mexico_City",
            names: ["Mexico City"]
        },
        {
            zone: "America/Miquelon",
            names: ["PM", "Saint Pierre and Miquelon", "Saint-Pierre"]
        },
        {
            zone: "America/Moncton",
            names: ["Moncton"]
        },
        {
            zone: "America/Monterrey",
            names: ["Monterrey"]
        },
        {
            zone: "America/Montevideo",
            names: ["UY", "Uruguay", "Montevideo", "UYT", "Uruguay Time"]
        },
        {
            zone: "America/Montreal",
            names: ["Montreal"]
        },
        {
            zone: "America/Montserrat",
            names: ["MS", "Montserrat", "Plymouth"]
        },
        {
            zone: "America/Nassau",
            names: ["BS", "Bahamas", "Nassau"]
        },
        {
            zone: "America/New_York",
            names: ["New York", "EDT", "Eastern Daylight Time"]
        },
        {
            zone: "America/Nipigon",
            names: ["Nipigon"]
        },
        {
            zone: "America/Nome",
            names: ["Nome"]
        },
        {
            zone: "America/Noronha",
            names: ["Noronha"]
        },
        {
            zone: "America/North_Dakota/Beulah",
            names: ["Beulah"]
        },
        {
            zone: "America/North_Dakota/Center",
            names: ["Center"]
        },
        {
            zone: "America/North_Dakota/New_Salem",
            names: ["New Salem"]
        },
        {
            zone: "America/Ojinaga",
            names: ["Ojinaga"]
        },
        {
            zone: "America/Panama",
            names: ["PA", "Panama", "Panama City"]
        },
        {
            zone: "America/Paramaribo",
            names: ["SR", "Suriname", "Paramaribo", "SRT", "Suriname Time"]
        },
        {
            zone: "America/Phoenix",
            names: ["Phoenix"]
        },
        {
            zone: "America/Port-au-Prince",
            names: ["HT", "Haiti", "Port-au-Prince"]
        },
        {
            zone: "America/Port_of_Spain",
            names: ["TT", "Trinidad and Tobago", "Port of Spain"]
        },
        {
            zone: "America/Porto_Velho",
            names: ["Porto Velho"]
        },
        {
            zone: "America/Puerto_Rico",
            names: ["PR", "Puerto Rico", "San Juan"]
        },
        {
            zone: "America/Rainy_River",
            names: ["Rainy River"]
        },
        {
            zone: "America/Rankin_Inlet",
            names: ["Rankin Inlet"]
        },
        {
            zone: "America/Recife",
            names: ["Recife"]
        },
        {
            zone: "America/Regina",
            names: ["Regina"]
        },
        {
            zone: "America/Resolute",
            names: ["Resolute"]
        },
        {
            zone: "America/Rio_Branco",
            names: ["Rio Branco"]
        },
        {
            zone: "America/Santarem",
            names: ["Santarem"]
        },
        {
            zone: "America/Santiago",
            names: ["CL", "Chile", "Santiago", "CLT", "Chile Standard Time"]
        },
        {
            zone: "America/Santo_Domingo",
            names: ["DO", "Dominican Republic", "Santo Domingo"]
        },
        {
            zone: "America/Sao_Paulo",
            names: ["Sao Paulo"]
        },
        {
            zone: "America/Scoresbysund",
            names: ["Scoresbysund"]
        },
        {
            zone: "America/Sitka",
            names: ["Sitka"]
        },
        {
            zone: "America/St_Barthelemy",
            names: ["BL", "Saint Barthélemy", "Gustavia"]
        },
        {
            zone: "America/St_Johns",
            names: ["St. John's", "NST", "Newfoundland Standard Time"]
        },
        {
            zone: "America/St_Kitts",
            names: ["KN", "Saint Kitts and Nevis", "Basseterre"]
        },
        {
            zone: "America/St_Lucia",
            names: ["LC", "Saint Lucia", "Castries"]
        },
        {
            zone: "America/St_Thomas",
            names: ["VI", "U.S. Virgin Islands", "Charlotte Amalie"]
        },
        {
            zone: "America/St_Vincent",
            names: ["VC", "Saint Vincent and the Grenadines", "Kingstown"]
        },
        {
            zone: "America/Swift_Current",
            names: ["Swift Current"]
        },
        {
            zone: "America/Tegucigalpa",
            names: ["HN", "Honduras", "Tegucigalpa"]
        },
        {
            zone: "America/Thule",
            names: ["Thule"]
        },
        {
            zone: "America/Thunder_Bay",
            names: ["Thunder Bay"]
        },
        {
            zone: "America/Tijuana",
            names: ["Tijuana"]
        },
        {
            zone: "America/Toronto",
            names: ["Toronto"]
        },
        {
            zone: "America/Tortola",
            names: ["VG", "British Virgin Islands", "Road Town"]
        },
        {
            zone: "America/Vancouver",
            names: ["Vancouver"]
        },
        {
            zone: "America/Virgin",
            names: ["Virgin"]
        },
        {
            zone: "America/Whitehorse",
            names: ["Whitehorse"]
        },
        {
            zone: "America/Winnipeg",
            names: ["Winnipeg"]
        },
        {
            zone: "America/Yakutat",
            names: ["Yakutat"]
        },
        {
            zone: "America/Yellowknife",
            names: ["Yellowknife"]
        },
        {
            zone: "Antarctica/Casey",
            names: ["AQ", "Antarctica", "Casey"]
        },
        {
            zone: "Antarctica/Davis",
            names: ["Davis"]
        },
        {
            zone: "Antarctica/DumontDUrville",
            names: ["Dumont d'Urville"]
        },
        {
            zone: "Antarctica/Macquarie",
            names: ["Macquarie"]
        },
        {
            zone: "Antarctica/Mawson",
            names: ["Mawson"]
        },
        {
            zone: "Antarctica/McMurdo",
            names: ["McMurdo"]
        },
        {
            zone: "Antarctica/Palmer",
            names: ["Palmer"]
        },
        {
            zone: "Antarctica/Rothera",
            names: ["Rothera"]
        },
        {
            zone: "Antarctica/Syowa",
            names: ["Syowa"]
        },
        {
            zone: "Antarctica/Troll",
            names: ["Troll"]
        },
        {
            zone: "Antarctica/Vostok",
            names: ["Vostok"]
        },
        {
            zone: "Arctic/Longyearbyen",
            names: ["SJ", "Svalbard and Jan Mayen", "Longyearbyen"]
        },
        {
            zone: "Asia/Aden",
            names: ["YE", "Yemen", "Sana'a"]
        },
        {
            zone: "Asia/Almaty",
            names: ["KZ", "Kazakhstan", "Astana", "ALMT", "Alma-Ata Time"]
        },
        {
            zone: "Asia/Amman",
            names: ["JO", "Jordan", "Amman"]
        },
        {
            zone: "Asia/Anadyr",
            names: ["RU", "Russia", "Moscow", "ANAT", "Anadyr Time"]
        },
        {
            zone: "Asia/Aqtau",
            names: ["Aqtau"]
        },
        {
            zone: "Asia/Aqtobe",
            names: ["Aqtobe"]
        },
        {
            zone: "Asia/Ashgabat",
            names: ["TM", "Turkmenistan", "Ashgabat", "TMT", "Turkmenistan Time"]
        },
        {
            zone: "Asia/Atyrau",
            names: ["Atyrau"]
        },
        {
            zone: "Asia/Baghdad",
            names: ["IQ", "Iraq", "Baghdad"]
        },
        {
            zone: "Asia/Baku",
            names: ["AZ", "Azerbaijan", "Baku", "AZT", "Azerbaijan Time"]
        },
        {
            zone: "Asia/Bangkok",
            names: ["TH", "Thailand", "Bangkok", "ICT", "Indochina Time"]
        },
        {
            zone: "Asia/Barnaul",
            names: ["Barnaul"]
        },
        {
            zone: "Asia/Beirut",
            names: ["LB", "Lebanon", "Beirut"]
        },
        {
            zone: "Asia/Bishkek",
            names: ["KG", "Kyrgyzstan", "Bishkek", "KGT", "Kyrgyzstan Time"]
        },
        {
            zone: "Asia/Brunei",
            names: ["BN", "Brunei", "Bandar Seri Begawan", "BNT", "Brunei Darussalam Time"]
        },
        {
            zone: "Asia/Chita",
            names: ["Chita"]
        },
        {
            zone: "Asia/Choibalsan",
            names: ["Choibalsan"]
        },
        {
            zone: "Asia/Colombo",
            names: ["LK", "Sri Lanka", "Sri Jayawardenepura Kotte"]
        },
        {
            zone: "Asia/Damascus",
            names: ["SY", "Syria", "Damascus"]
        },
        {
            zone: "Asia/Dhaka",
            names: ["BD", "Bangladesh", "Dhaka", "BST", "Bangladesh Standard Time"]
        },
        {
            zone: "Asia/Dili",
            names: ["TL", "Timor-Leste", "Dili"]
        },
        {
            zone: "Asia/Dubai",
            names: ["AE", "United Arab Emirates", "Abu Dhabi", "GST", "Gulf Standard Time"]
        },
        {
            zone: "Asia/Dushanbe",
            names: ["TJ", "Tajikistan", "Dushanbe", "TJT", "Tajikistan Time"]
        },
        {
            zone: "Asia/Famagusta",
            names: ["CY", "Cyprus", "Nicosia"]
        },
        {
            zone: "Asia/Gaza",
            names: ["PS", "Palestine", "Ramallah"]
        },
        {
            zone: "Asia/Hebron",
            names: ["Hebron"]
        },
        {
            zone: "Asia/Ho_Chi_Minh",
            names: ["VN", "Vietnam", "Hanoi"]
        },
        {
            zone: "Asia/Hong_Kong",
            names: ["HK", "Hong Kong", "HKT", "Hong Kong Time"]
        },
        {
            zone: "Asia/Hovd",
            names: ["Hovd"]
        },
        {
            zone: "Asia/Irkutsk",
            names: ["Irkutsk"]
        },
        {
            zone: "Asia/Jakarta",
            names: ["ID", "Indonesia", "Jakarta", "WIB", "Western Indonesia Time"]
        },
        {
            zone: "Asia/Jayapura",
            names: ["Jayapura"]
        },
        {
            zone: "Asia/Jerusalem",
            names: ["IL", "Israel", "Jerusalem", "IDT", "Israel Daylight Time"]
        },
        {
            zone: "Asia/Kabul",
            names: ["AF", "Afghanistan", "Kabul", "AFT", "Afghanistan Time"]
        },
        {
            zone: "Asia/Kamchatka",
            names: ["Kamchatka"]
        },
        {
            zone: "Asia/Karachi",
            names: ["PK", "Pakistan", "Islamabad", "PKT", "Pakistan Standard Time"]
        },
        {
            zone: "Asia/Kathmandu",
            names: ["NP", "Nepal", "Kathmandu", "NPT", "Nepal Time"]
        },
        {
            zone: "Asia/Khandyga",
            names: ["Khandyga"]
        },
        {
            zone: "Asia/Kolkata",
            names: ["IN", "India", "New Delhi", "IST", "Indian Standard Time"]
        },
        {
            zone: "Asia/Krasnoyarsk",
            names: ["Krasnoyarsk"]
        },
        {
            zone: "Asia/Kuala_Lumpur",
            names: ["MY", "Malaysia", "Kuala Lumpur", "MYT", "Malaysia Time"]
        },
        {
            zone: "Asia/Kuching",
            names: ["Kuching"]
        },
        {
            zone: "Asia/Macau",
            names: ["MO", "Macau"]
        },
        {
            zone: "Asia/Magadan",
            names: ["Magadan"]
        },
        {
            zone: "Asia/Makassar",
            names: ["Makassar"]
        },
        {
            zone: "Asia/Manila",
            names: ["PH", "Philippines", "Manila", "PST", "Philippine Standard Time"]
        },
        {
            zone: "Asia/Nicosia",
            names: ["Nicosia"]
        },
        {
            zone: "Asia/Novokuznetsk",
            names: ["Novokuznetsk"]
        },
        {
            zone: "Asia/Novosibirsk",
            names: ["Novosibirsk"]
        },
        {
            zone: "Asia/Omsk",
            names: ["Omsk"]
        },
        {
            zone: "Asia/Oral",
            names: ["Oral"]
        },
        {
            zone: "Asia/Phnom_Penh",
            names: ["KH", "Cambodia", "Phnom Penh"]
        },
        {
            zone: "Asia/Pontianak",
            names: ["Pontianak"]
        },
        {
            zone: "Asia/Pyongyang",
            names: ["KP", "North Korea", "Pyongyang", "KST", "Korea Standard Time"]
        },
        {
            zone: "Asia/Qatar",
            names: ["QA", "Qatar", "Doha"]
        },
        {
            zone: "Asia/Qostanay",
            names: ["Qostanay"]
        },
        {
            zone: "Asia/Qyzylorda",
            names: ["Qyzylorda"]
        },
        {
            zone: "Asia/Rangoon",
            names: ["Rangoon"]
        },
        {
            zone: "Asia/Riyadh",
            names: ["SA", "Saudi Arabia", "Riyadh"]
        },
        {
            zone: "Asia/Sakhalin",
            names: ["Sakhalin"]
        },
        {
            zone: "Asia/Samarkand",
            names: ["UZ", "Uzbekistan", "Tashkent", "UZT", "Uzbekistan Time"]
        },
        {
            zone: "Asia/Seoul",
            names: ["KR", "South Korea", "Seoul"]
        },
        {
            zone: "Asia/Shanghai",
            names: ["CN", "China", "Beijing", "CST", "China Standard Time"]
        },
        {
            zone: "Asia/Singapore",
            names: ["SG", "Singapore", "SGT", "Singapore Time"]
        },
        {
            zone: "Asia/Srednekolymsk",
            names: ["Srednekolymsk"]
        },
        {
            zone: "Asia/Taipei",
            names: ["TW", "Taiwan", "Taipei"]
        },
        {
            zone: "Asia/Tashkent",
            names: ["Tashkent"]
        },
        {
            zone: "Asia/Tbilisi",
            names: ["GE", "Georgia", "Tbilisi", "GET", "Georgia Standard Time"]
        },
        {
            zone: "Asia/Tehran",
            names: ["IR", "Iran", "Tehran", "IRST", "Iran Standard Time"]
        },
        {
            zone: "Asia/Thimphu",
            names: ["BT", "Bhutan", "Thimphu", "BTT", "Bhutan Time"]
        },
        {
            zone: "Asia/Tokyo",
            names: ["JP", "Japan", "Tokyo", "JST", "Japan Standard Time"]
        },
        {
            zone: "Asia/Tomsk",
            names: ["Tomsk"]
        },
        {
            zone: "Asia/Ulaanbaatar",
            names: ["MN", "Mongolia", "Ulaanbaatar", "ULAT", "Ulaanbaatar Time"]
        },
        {
            zone: "Asia/Urumqi",
            names: ["Urumqi"]
        },
        {
            zone: "Asia/Ust-Nera",
            names: ["Ust-Nera"]
        },
        {
            zone: "Asia/Vientiane",
            names: ["LA", "Laos", "Vientiane"]
        },
        {
            zone: "Asia/Vladivostok",
            names: ["Vladivostok"]
        },
        {
            zone: "Asia/Yakutsk",
            names: ["Yakutsk"]
        },
        {
            zone: "Asia/Yangon",
            names: ["Yangon"]
        },
        {
            zone: "Asia/Yekaterinburg",
            names: ["Yekaterinburg"]
        },
        {
            zone: "Asia/Yerevan",
            names: ["AM", "Armenia", "Yerevan", "AMT", "Armenia Time"]
        },
        {
            zone: "Atlantic/Azores",
            names: ["PT", "Portugal", "Lisbon", "AZOT", "Azores Time"]
        },
        {
            zone: "Atlantic/Bermuda",
            names: ["BM", "Bermuda", "Hamilton"]
        },
        {
            zone: "Atlantic/Canary",
            names: ["ES", "Spain", "Madrid"]
        },
        {
            zone: "Atlantic/Cape_Verde",
            names: ["CV", "Cape Verde", "Praia", "CVT", "Cape Verde Time"]
        },
        {
            zone: "Atlantic/Faeroe",
            names: ["FO", "Faroe Islands", "Tórshavn"]
        },
        {
            zone: "Atlantic/Faroe",
            names: ["Faroe"]
        },
        {
            zone: "Atlantic/Jan_Mayen",
            names: ["Jan Mayen"]
        },
        {
            zone: "Atlantic/Madeira",
            names: ["Madeira"]
        },
        {
            zone: "Atlantic/Reykjavik",
            names: ["IS", "Iceland", "Reykjavik"]
        },
        {
            zone: "Atlantic/South_Georgia",
            names: ["GS", "South Georgia and the South Sandwich Islands", "King Edward Point"]
        },
        {
            zone: "Atlantic/Stanley",
            names: ["FK", "Falkland Islands", "Stanley", "FKT", "Falkland Islands Time"]
        },
        {
            zone: "Australia/Adelaide",
            names: ["AU", "Australia", "Canberra", "ACST", "Australian Central Standard Time"]
        },
        {
            zone: "Australia/Brisbane",
            names: ["Brisbane", "AEST", "Australian Eastern Standard Time"]
        },
        {
            zone: "Australia/Broken_Hill",
            names: ["Broken Hill"]
        },
        {
            zone: "Australia/Currie",
            names: ["Currie"]
        },
        {
            zone: "Australia/Darwin",
            names: ["Darwin"]
        },
        {
            zone: "Australia/Eucla",
            names: ["Eucla"]
        },
        {
            zone: "Australia/Hobart",
            names: ["Hobart"]
        },
        {
            zone: "Australia/Lindeman",
            names: ["Lindeman"]
        },
        {
            zone: "Australia/Lord_Howe",
            names: ["Lord Howe"]
        },
        {
            zone: "Australia/Melbourne",
            names: ["Melbourne"]
        },
        {
            zone: "Australia/Perth",
            names: ["Perth", "AWST", "Australian Western Standard Time"]
        },
        {
            zone: "Australia/Sydney",
            names: ["Sydney"]
        },
        {
            zone: "Europe/Amsterdam",
            names: ["NL", "Netherlands", "Amsterdam"]
        },
        {
            zone: "Europe/Andorra",
            names: ["AD", "Andorra", "Andorra la Vella"]
        },
        {
            zone: "Europe/Athens",
            names: ["GR", "Greece", "Athens"]
        },
        {
            zone: "Europe/Belgrade",
            names: ["RS", "Serbia", "Belgrade"]
        },
        {
            zone: "Europe/Berlin",
            names: ["DE", "Germany", "Berlin"]
        },
        {
            zone: "Europe/Bratislava",
            names: ["SK", "Slovakia", "Bratislava"]
        },
        {
            zone: "Europe/Brussels",
            names: ["BE", "Belgium", "Brussels"]
        },
        {
            zone: "Europe/Bucharest",
            names: ["RO", "Romania", "Bucharest"]
        },
        {
            zone: "Europe/Budapest",
            names: ["HU", "Hungary", "Budapest"]
        },
        {
            zone: "Europe/Chisinau",
            names: ["MD", "Moldova", "Chișinău"]
        },
        {
            zone: "Europe/Copenhagen",
            names: ["DK", "Denmark", "Copenhagen"]
        },
        {
            zone: "Europe/Dublin",
            names: ["IE", "Ireland", "Dublin", "IST", "Irish Standard Time"]
        },
        {
            zone: "Europe/Gibraltar",
            names: ["GI", "Gibraltar"]
        },
        {
            zone: "Europe/Helsinki",
            names: ["FI", "Finland", "Helsinki"]
        },
        {
            zone: "Europe/Istanbul",
            names: ["TR", "Turkey", "Ankara", "TRT", "Turkey Time"]
        },
        {
            zone: "Europe/Kaliningrad",
            names: ["Kaliningrad"]
        },
        {
            zone: "Europe/Kiev",
            names: ["UA", "Ukraine", "Kyiv"]
        },
        {
            zone: "Europe/Kyiv",
            names: ["Kyiv"]
        },
        {
            zone: "Europe/Lisbon",
            names: ["Lisbon"]
        },
        {
            zone: "Europe/Ljubljana",
            names: ["SI", "Slovenia", "Ljubljana"]
        },
        {
            zone: "Europe/London",
            names: ["GB", "United Kingdom", "London", "BST", "British Summer Time"]
        },
        {
            zone: "Europe/Luxembourg",
            names: ["LU", "Luxembourg"]
        },
        {
            zone: "Europe/Madrid",
            names: ["Madrid"]
        },
        {
            zone: "Europe/Malta",
            names: ["MT", "Malta", "Valletta"]
        },
        {
            zone: "Europe/Mariehamn",
            names: ["AX", "Åland Islands", "Mariehamn"]
        },
        {
            zone: "Europe/Minsk",
            names: ["BY", "Belarus", "Minsk", "MSK", "Moscow Time"]
        },
        {
            zone: "Europe/Monaco",
            names: ["MC", "Monaco"]
        },
        {
            zone: "Europe/Moscow",
            names: ["Moscow"]
        },
        {
            zone: "Europe/Oslo",
            names: ["NO", "Norway", "Oslo"]
        },
        {
            zone: "Europe/Paris",
            names: ["FR", "France", "Paris"]
        },
        {
            zone: "Europe/Podgorica",
            names: ["ME", "Montenegro", "Podgorica"]
        },
        {
            zone: "Europe/Prague",
            names: ["CZ", "Czech Republic", "Prague"]
        },
        {
            zone: "Europe/Riga",
            names: ["LV", "Latvia", "Riga"]
        },
        {
            zone: "Europe/Rome",
            names: ["IT", "Italy", "Rome"]
        },
        {
            zone: "Europe/Samara",
            names: ["Samara"]
        },
        {
            zone: "Europe/San_Marino",
            names: ["SM", "San Marino"]
        },
        {
            zone: "Europe/Sarajevo",
            names: ["BA", "Bosnia and Herzegovina", "Sarajevo"]
        },
        {
            zone: "Europe/Saratov",
            names: ["Saratov"]
        },
        {
            zone: "Europe/Simferopol",
            names: ["Simferopol"]
        },
        {
            zone: "Europe/Skopje",
            names: ["MK", "North Macedonia", "Skopje"]
        },
        {
            zone: "Europe/Sofia",
            names: ["BG", "Bulgaria", "Sofia"]
        },
        {
            zone: "Europe/Stockholm",
            names: ["SE", "Sweden", "Stockholm"]
        },
        {
            zone: "Europe/Tallinn",
            names: ["EE", "Estonia", "Tallinn"]
        },
        {
            zone: "Europe/Tirane",
            names: ["AL", "Albania", "Tirana"]
        },
        {
            zone: "Europe/Ulyanovsk",
            names: ["Ulyanovsk"]
        },
        {
            zone: "Europe/Uzhgorod",
            names: ["Uzhgorod"]
        },
        {
            zone: "Europe/Vaduz",
            names: ["LI", "Liechtenstein", "Vaduz"]
        },
        {
            zone: "Europe/Vatican",
            names: ["VA", "Vatican City"]
        },
        {
            zone: "Europe/Vienna",
            names: ["AT", "Austria", "Vienna"]
        },
        {
            zone: "Europe/Vilnius",
            names: ["LT", "Lithuania", "Vilnius"]
        },
        {
            zone: "Europe/Volgograd",
            names: ["Volgograd"]
        },
        {
            zone: "Europe/Warsaw",
            names: ["PL", "Poland", "Warsaw"]
        },
        {
            zone: "Europe/Zagreb",
            names: ["HR", "Croatia", "Zagreb"]
        },
        {
            zone: "Europe/Zurich",
            names: ["CH", "Switzerland", "Bern"]
        },
        {
            zone: "Indian/Antananarivo",
            names: ["MG", "Madagascar", "Antananarivo"]
        },
        {
            zone: "Indian/Chagos",
            names: ["IO", "British Indian Ocean Territory", "Diego Garcia"]
        },
        {
            zone: "Indian/Christmas",
            names: ["CX", "Christmas Island", "Flying Fish Cove"]
        },
        {
            zone: "Indian/Cocos",
            names: ["CC", "Cocos (Keeling) Islands", "West Island"]
        },
        {
            zone: "Indian/Comoro",
            names: ["KM", "Comoros", "Moroni"]
        },
        {
            zone: "Indian/Kerguelen",
            names: ["TF", "French Southern Territories", "Port-aux-Français"]
        },
        {
            zone: "Indian/Mahe",
            names: ["SC", "Seychelles", "Victoria"]
        },
        {
            zone: "Indian/Maldives",
            names: ["MV", "Maldives", "Malé"]
        },
        {
            zone: "Indian/Mauritius",
            names: ["MU", "Mauritius", "Port Louis"]
        },
        {
            zone: "Indian/Mayotte",
            names: ["YT", "Mayotte", "Mamoudzou"]
        },
        {
            zone: "Indian/Reunion",
            names: ["RE", "Réunion", "Saint-Denis"]
        },
        {
            zone: "Pacific/Apia",
            names: ["WS", "Samoa", "Apia"]
        },
        {
            zone: "Pacific/Auckland",
            names: ["NZ", "New Zealand", "Wellington", "NZST", "New Zealand Standard Time"]
        },
        {
            zone: "Pacific/Bougainville",
            names: ["PG", "Papua New Guinea", "Port Moresby"]
        },
        {
            zone: "Pacific/Chatham",
            names: ["Chatham"]
        },
        {
            zone: "Pacific/Chuuk",
            names: ["FM", "Micronesia", "Palikir"]
        },
        {
            zone: "Pacific/Easter",
            names: ["Easter"]
        },
        {
            zone: "Pacific/Efate",
            names: ["VU", "Vanuatu", "Port Vila"]
        },
        {
            zone: "Pacific/Enderbury",
            names: ["Enderbury"]
        },
        {
            zone: "Pacific/Fakaofo",
            names: ["TK", "Tokelau", "Fakaofo"]
        },
        {
            zone: "Pacific/Fiji",
            names: ["FJ", "Fiji", "Suva"]
        },
        {
            zone: "Pacific/Funafuti",
            names: ["TV", "Tuvalu", "Funafuti"]
        },
        {
            zone: "Pacific/Galapagos",
            names: ["Galapagos"]
        },
        {
            zone: "Pacific/Gambier",
            names: ["Gambier"]
        },
        {
            zone: "Pacific/Guadalcanal",
            names: ["SB", "Solomon Islands", "Honiara"]
        },
        {
            zone: "Pacific/Guam",
            names: ["GU", "Guam", "Hagåtña"]
        },
        {
            zone: "Pacific/Honolulu",
            names: ["Honolulu"]
        },
        {
            zone: "Pacific/Kanton",
            names: ["Kanton"]
        },
        {
            zone: "Pacific/Kiritimati",
            names: ["Kiritimati"]
        },
        {
            zone: "Pacific/Kosrae",
            names: ["Kosrae"]
        },
        {
            zone: "Pacific/Kwajalein",
            names: ["MH", "Marshall Islands", "Majuro"]
        },
        {
            zone: "Pacific/Majuro",
            names: ["Majuro"]
        },
        {
            zone: "Pacific/Marquesas",
            names: ["Marquesas"]
        },
        {
            zone: "Pacific/Midway",
            names: ["Midway"]
        },
        {
            zone: "Pacific/Nauru",
            names: ["NR", "Nauru", "Yaren"]
        },
        {
            zone: "Pacific/Niue",
            names: ["NU", "Niue", "Alofi"]
        },
        {
            zone: "Pacific/Norfolk",
            names: ["NF", "Norfolk Island", "Kingston"]
        },
        {
            zone: "Pacific/Noumea",
            names: ["NC", "New Caledonia", "Nouméa"]
        },
        {
            zone: "Pacific/Pago_Pago",
            names: ["AS", "American Samoa", "Pago Pago"]
        },
        {
            zone: "Pacific/Palau",
            names: ["PW", "Palau", "Ngerulmud"]
        },
        {
            zone: "Pacific/Pitcairn",
            names: ["PN", "Pitcairn Islands", "Adamstown"]
        },
        {
            zone: "Pacific/Pohnpei",
            names: ["Pohnpei"]
        },
        {
            zone: "Pacific/Port_Moresby",
            names: ["Port Moresby"]
        },
        {
            zone: "Pacific/Rarotonga",
            names: ["CK", "Cook Islands", "Avarua"]
        },
        {
            zone: "Pacific/Saipan",
            names: ["MP", "Northern Mariana Islands", "Saipan"]
        },
        {
            zone: "Pacific/Tahiti",
            names: ["PF", "French Polynesia", "Papeete"]
        },
        {
            zone: "Pacific/Tarawa",
            names: ["Tarawa"]
        },
        {
            zone: "Pacific/Tongatapu",
            names: ["TO", "Tonga", "Nuku'alofa"]
        },
        {
            zone: "Pacific/Wake",
            names: ["Wake"]
        },
        {
            zone: "Pacific/Wallis",
            names: ["WF", "Wallis and Futuna", "Mata-Utu"]
        }
    ]

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}
