WindowsMessageManager = {
    CurrentWindowsMessage = {
        HWND = 0,
        Id = 0,
        wParam = 0,
        lParam = 0,
    }
}

WindowsMessages = {
    WM_MOUSEWHEEL = 522,
    WM_ACTIVATE = 6,
    WM_KILLFOCUS = 8,
}

function WindowsMessageManager.Update(hwnd, id, wparam, lparam)
    WindowsMessageManager.CurrentWindowsMessage.HWND = hwnd
    WindowsMessageManager.CurrentWindowsMessage.Id = id
    WindowsMessageManager.CurrentWindowsMessage.wParam = wparam
    WindowsMessageManager.CurrentWindowsMessage.lParam = lparam
end
