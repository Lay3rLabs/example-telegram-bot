use std::collections::HashMap;

use anyhow::{anyhow, Result};
use serde::{de::DeserializeOwned, Deserialize, Serialize};
use wstd::{
    http::{body::IncomingBody, Client, IntoBody, Request, Response, StatusCode},
    io::{empty, AsyncRead},
};

pub struct TelegramBot {
    pub token: String,
    pub chat_id: String,
}

impl TelegramBot {
    pub fn new() -> Result<Self> {
        Ok(Self {
            token: std::env::var("WAVS_ENV_TELEGRAM_BOT_TOKEN")?,
            chat_id: std::env::var("WAVS_ENV_TELEGRAM_CHAT_ID")?,
        })
    }

    pub async fn get_me(&self) -> Result<TelegramUser> {
        self.make_request_empty("getMe").await
    }

    pub async fn send_message(&self, text: impl ToString) -> Result<TelegramMessage> {
        let mut form_data = HashMap::new();
        form_data.insert("chat_id".to_string(), self.chat_id.to_string());
        form_data.insert("text".to_string(), text.to_string());

        self.make_request_params("sendMessage", form_data).await
    }

    async fn make_request_empty<T: DeserializeOwned>(&self, method: &str) -> Result<T> {
        let url = format!("https://api.telegram.org/bot{}/{}", self.token, method);

        let request = Request::post(url).body(empty()).map_err(|e| anyhow!(e))?;

        let res = Client::new().send(request).await.map_err(|e| anyhow!(e))?;

        handle_response(res).await
    }

    async fn make_request_params<T: DeserializeOwned>(
        &self,
        method: &str,
        form_data: HashMap<String, String>,
    ) -> Result<T> {
        let url = format!("https://api.telegram.org/bot{}/{}", self.token, method);

        let mut body = String::new();
        for (key, value) in form_data {
            if !body.is_empty() {
                body += &format!("&");
            }
            body += &format!("{}={}\n", key, value);
        }

        let request = Request::post(url)
            .header("content-type", "application/x-www-form-urlencoded")
            .body(body.into_body())
            .map_err(|e| anyhow!(e))?;

        let res = Client::new().send(request).await.map_err(|e| anyhow!(e))?;

        handle_response(res).await
    }
}

async fn handle_response<T: DeserializeOwned>(mut resp: Response<IncomingBody>) -> Result<T> {
    match resp.status() {
        StatusCode::OK => {
            let body = resp.body_mut();
            let mut body_buf = Vec::new();
            body.read_to_end(&mut body_buf)
                .await
                .map_err(|e| anyhow!(e))?;
            let json: TelegramResult<T> =
                serde_json::from_slice(&body_buf).map_err(|e| anyhow!(e))?;

            if json.ok {
                Ok(json.result)
            } else {
                Err(anyhow!("Telegram API error"))
            }
        }
        status => Err(anyhow!("unexpected status code: {status}")),
    }
}
#[derive(Deserialize, Serialize, Debug)]
struct TelegramResult<T> {
    ok: bool,
    result: T,
}

#[derive(Deserialize, Serialize, Debug)]
pub struct TelegramMessage {
    pub message_id: i64,
    pub message_thread_id: Option<i64>,
    pub from: TelegramUser,
    pub chat: TelegramChat,
    pub date: u64,
    pub text: Option<String>,
}

#[derive(Deserialize, Serialize, Debug)]
pub struct TelegramUser {
    pub id: i64,
    pub is_bot: bool,
    pub first_name: String,
    pub username: Option<String>,
}

#[derive(Deserialize, Serialize, Debug)]
pub struct TelegramChat {
    pub id: i64,
    #[serde(rename = "type")]
    pub chat_type: TelegramChatType,
    pub title: Option<String>,
    pub username: Option<String>,
    pub first_name: Option<String>,
    pub last_name: Option<String>,
}

#[derive(Deserialize, Serialize, Debug, PartialEq, Eq)]
pub enum TelegramChatType {
    #[serde(rename = "private")]
    Private,
    #[serde(rename = "group")]
    Group,
    #[serde(rename = "supergroup")]
    SuperGroup,
    #[serde(rename = "channel")]
    Channel,
}
