#Requires AutoHotkey v2.0
#SingleInstance Force

; Định nghĩa đường dẫn ảnh
normalColors := [
    "C:\\AutoClick\\color_normal_1.png",  ; Bọ trắng
    "C:\\AutoClick\\color_normal_2.png",  ; Bọ xanh lục
    "C:\\AutoClick\\color_normal_3.png"   ; Bọ xanh dương
]
rareColors := [
    "C:\\AutoClick\\color_rare.png",  ; Bọ tím
    "C:\\AutoClick\\color_rare_2.png"  ; Bọ Vvip (RainBow)
]
sellButton := "C:\\AutoClick\\sell_button.png"  ; Nút "Bán ngay"
keepButton := "C:\\AutoClick\\keep_button.png"  ; Nút "Bảo quản"
crownWarning := "C:\\AutoClick\\crown_warning.png"  ; Thông báo có vương miện
confirmYes := "C:\\AutoClick\\confirm_yes.png"  ; Nút "Có" trong xác nhận bán"
okButton := "C:\\AutoClick\\ok_button.png"  ; Nút "OK" sau khi bán
okMoTheButton := "C:\\AutoClick\\ok_mothe.png"  ; Nút "OK" sau khi mở thẻ
moTheButton := "C:\\AutoClick\\mo_the.png"  ; Nút mở thẻ

; Biến đếm số lượng bọ bán và giữ
soLuongBan := 0
soLuongGiu := 0

; Thêm phím tắt để dừng script
Hotkey "F12", DungScript

; Hàm dừng script
DungScript(*) {
    MsgBox(Format("Edit : Bố Vũ Vĩ Đại!`nĐã bán: {} bọ`nĐã giữ: {} bọ", soLuongBan, soLuongGiu), "Thông báo", "0x40")
    ExitApp
}

NhanOK(okImage) {
    foundX := foundY := 0
    if !FileExist(okImage) {
        MsgBox("Lỗi: Không tìm thấy tệp ảnh: " . okImage, "Lỗi", "0x10")
        return
    }
    Loop 5 {
        if ImageSearch(&foundX, &foundY, 0, 0, A_ScreenWidth, A_ScreenHeight, "*30 " . okImage) {
            MouseMove(foundX + 10, foundY + 10)
            Sleep 200
            Click()
            return
        }
        Sleep 100
    }
}

Loop {
    Sleep 100
    foundX := foundY := 0
    isNormal := false
    isRare := false

    for color in normalColors {
        if ImageSearch(&foundX, &foundY, 0, 0, A_ScreenWidth, A_ScreenHeight, "*30 " . color) {
            isNormal := true
            break
        }
    }

    if !isNormal {
        for rareColor in rareColors {
            if ImageSearch(&foundX, &foundY, 0, 0, A_ScreenWidth, A_ScreenHeight, "*30 " . rareColor) {
                isRare := true
                break
            }
        }
    }

    if isNormal {
        if ImageSearch(&foundX, &foundY, 0, 0, A_ScreenWidth, A_ScreenHeight, "*30 " . sellButton) {
            MouseMove(foundX + 10, foundY + 10)
            Sleep 300
            Click()
            soLuongBan++
            Sleep 800
            NhanOK(okButton)
        }
    } else if isRare {
        if ImageSearch(&foundX, &foundY, 0, 0, A_ScreenWidth, A_ScreenHeight, "*30 " . keepButton) {
            MouseMove(foundX + 10, foundY + 10)
            Sleep 300
            Click()
            soLuongGiu++
        }
    }
    
    ; Kiểm tra và mở thẻ nếu có
    if ImageSearch(&foundX, &foundY, 0, 0, A_ScreenWidth, A_ScreenHeight, "*30 " . moTheButton) {
        MouseMove(foundX + 10, foundY + 10)
        Sleep 300
        Click()
        Sleep 800
        NhanOK(okMoTheButton)
    }
    
    Sleep 300
}
