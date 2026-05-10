
DELIMITER //

CREATE TRIGGER PreventStatusRevert
BEFORE UPDATE ON Appointments
FOR EACH ROW
BEGIN
    -- Lỗi logic: Dùng NEW thay vì OLD khiến toàn bộ hệ thống bị "tê liệt"

    IF NEW.status = 'Completed' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi: Không được phép thao tác trên lịch khám này!';
    END IF;

END //

DELIMITER ;
-- A
UPDATE Appointments
SET status = 'Completed'
WHERE appointment_id = 104;
-- NEW.status là giá trị mới người dùng muốn đổi sang, nếu kiểm tra bằng NEW thì mọi cập nhật sang 'Completed' đều bị chặn ra chạy ra dòng thông báo 

-- B
DROP TRIGGER PreventStatusRevert
DELIMITER //

CREATE TRIGGER PreventStatusRevert
BEFORE UPDATE ON Appointments
FOR EACH ROW
BEGIN
    IF OLD.status = 'Completed' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi: Không được phép cập nhật lịch khám đã hoàn thành!';
    END IF;
END //

DELIMITER ;
