#Requires AutoHotkey v2.0
#SingleInstance Force

; Định nghĩa đường dẫn ảnh
normalColors := [
    "C:\AutoClick\color_normal_1.png",  ; Bọ trắng
    "C:\AutoClick\color_normal_2.png",  ; Bọ xanh lục
    "C:\AutoClick\color_normal_3.png"   ; Bọ xanh dương
]
rareColors := [
    "C:\AutoClick\color_rare.png",  ; Bọ tím
    "C:\AutoClick\color_rare_2.png"  ; Bọ Vvip (RainBow)
]
sellButton := "C:\AutoClick\sell_button.png"  ; Nút "Bán ngay"
keepButton := "C:\AutoClick\keep_button.png"  ; Nút "Bảo quản"
crownWarning := "C:\AutoClick\crown_warning.png"  ; Thông báo có vương miện
confirmYes := "C:\AutoClick\confirm_yes.png"  ; Nút "Có" trong xác nhận bán

; Biến đếm số lượng bọ bán và giữ
soLuongBan := 0
soLuongGiu := 0

; Thêm phím tắt để dừng script
Hotkey "F12", DungScript

; Hàm dừng script
DungScript(*) {
    MsgBox("Script đã dừng!`nĐã bán: " . soLuongBan . " bọ`nĐã giữ: " . soLuongGiu . " bọ")
    ExitApp
}

Loop {
    Sleep 150  ; Đợi 150ms trước mỗi lần kiểm tra

    foundX := foundY := 0
    isNormal := false
    isRare := false

    ; 🔍 Kiểm tra xem có bọ thường không (bất kỳ màu nào trong danh sách)
    for color in normalColors {
        if ImageSearch(&foundX, &foundY, 0, 0, A_ScreenWidth, A_ScreenHeight, "*30 " color) {
            isNormal := true
            break  ; Nếu tìm thấy 1 màu thì dừng kiểm tra
        }
    }

    ; 🔍 Kiểm tra xem có bọ hiếm (bọ tím, bọ Vvip) không
    if !isNormal {  ; Chỉ kiểm tra nếu không phải bọ thường để tối ưu
        for rareColor in rareColors {
            if ImageSearch(&foundX, &foundY, 0, 0, A_ScreenWidth, A_ScreenHeight, "*30 " rareColor) {
                isRare := true
                break
            }
        }
    }

    ; ✅ Nếu là bọ thường → Bán ngay
    if isNormal {
        if ImageSearch(&foundX, &foundY, 0, 0, A_ScreenWidth, A_ScreenHeight, "*30 " sellButton) {
            MouseMove(foundX + 10, foundY + 10)
            Sleep 200
            Click()
            soLuongBan++
            
            ; Xử lý thông báo vương miện nếu xuất hiện
            Sleep 300
            XuLyThongBaoVuongMien()
        }
    }
    ; ✅ Nếu là bọ hiếm (bọ tím, bọ Vvip) → Luôn bảo quản
    else if isRare {
        if ImageSearch(&foundX, &foundY, 0, 0, A_ScreenWidth, A_ScreenHeight, "*30 " keepButton) {
            MouseMove(foundX + 10, foundY + 10)
            Sleep 300
            Click()
            soLuongGiu++
        }
    }
    
    Sleep 300
}

; Hàm xử lý thông báo vương miện
XuLyThongBaoVuongMien() {
    foundX := foundY := 0
    
    if ImageSearch(&foundX, &foundY, 0, 0, A_ScreenWidth, A_ScreenHeight, "*30 " crownWarning) {
        Sleep 300
        if ImageSearch(&foundX, &foundY, 0, 0, A_ScreenWidth, A_ScreenHeight, "*30 " confirmYes) {
            MouseMove(foundX + 10, foundY + 10)
            Sleep 200
            Click()
        }
    }
}