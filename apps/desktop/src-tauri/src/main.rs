// Prevents additional console window on Windows in release, DO NOT REMOVE!!
#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

use tauri::Manager;
use std::path::PathBuf;

#[tauri::command]
fn open_project_folder(relative_path: String) -> Result<String, String> {
    // Get base path from environment variable or use default
    let base_path = std::env::var("HOST_PROJECT_FOLDER")
        .unwrap_or_else(|_| "N://Mandats".to_string());

    // Combine base path with relative path
    let mut full_path = PathBuf::from(base_path);

    // Remove leading slash from relative path if present
    let clean_relative = relative_path.trim_start_matches('/').trim_start_matches('\\');
    full_path.push(clean_relative);

    // Convert to string for opening
    let path_str = full_path.to_string_lossy().to_string();

    println!("Opening folder: {}", path_str);

    // Open the folder using the system's default file explorer
    #[cfg(target_os = "windows")]
    {
        std::process::Command::new("explorer")
            .arg(&path_str)
            .spawn()
            .map_err(|e| format!("Failed to open folder: {}", e))?;
    }

    #[cfg(target_os = "macos")]
    {
        std::process::Command::new("open")
            .arg(&path_str)
            .spawn()
            .map_err(|e| format!("Failed to open folder: {}", e))?;
    }

    #[cfg(target_os = "linux")]
    {
        std::process::Command::new("xdg-open")
            .arg(&path_str)
            .spawn()
            .map_err(|e| format!("Failed to open folder: {}", e))?;
    }

    Ok(path_str)
}

#[tauri::command]
fn get_project_base_path() -> String {
    std::env::var("HOST_PROJECT_FOLDER")
        .unwrap_or_else(|_| "N://Mandats".to_string())
}

fn main() {
    // SECURITY WARNING: Setting environment variables to disable SSL verification
    // This makes the application vulnerable to man-in-the-middle attacks
    // Only use this in development or trusted network environments

    #[cfg(target_os = "linux")]
    {
        // For Linux/WebKit, disable TLS verification
        std::env::set_var("WEBKIT_DISABLE_TLS_VERIFICATION", "1");
    }

    #[cfg(target_os = "windows")]
    {
        // For Windows, we'll handle SSL errors in the webview
        std::env::set_var("WEBVIEW2_ADDITIONAL_BROWSER_ARGUMENTS", "--ignore-certificate-errors");
    }

    tauri::Builder::default()
        .plugin(tauri_plugin_dialog::init())
        .plugin(tauri_plugin_opener::init())
        .plugin(tauri_plugin_shell::init())
        .invoke_handler(tauri::generate_handler![
            open_project_folder,
            get_project_base_path
        ])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}


