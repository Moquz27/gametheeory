# Checklist yêu cầu project và vấn đáp

## 1. Yêu cầu cốt lõi từ topic

Project cần chứng minh nhóm hiểu và trình bày được các nội dung sau:

- Ứng dụng của ma trận trong trò chơi hai người tổng bằng 0.
- Chiến lược thuần, chiến lược hỗn hợp, điểm yên ngựa và định lý minimax.
- Quan hệ giữa trò chơi ma trận và quy hoạch tuyến tính.
- Cách xây dựng ma trận payoff `A = (a_ij)`.
- Điều kiện saddle point bằng nguyên lý maximin và minimax.
- Cách tính chiến lược hỗn hợp và giá trị trò chơi `x^T A y`.
- Mô hình quy hoạch tuyến tính tương đương.
- Thuật toán giải trò chơi `2 x 2` và trường hợp tổng quát `N x M`.
- Ít nhất 3 tình huống ứng dụng thực tế, mỗi tình huống có bối cảnh, giả định, diễn giải từng phần tử ma trận và ý nghĩa chiến lược tối ưu.
- Tài liệu tham khảo học thuật đầy đủ, tối thiểu khoảng 3 đến 5 nguồn uy tín.

## 2. Yêu cầu về báo cáo

- Báo cáo dài 15 đến 25 trang, không tính tài liệu tham khảo.
- Font size 12, line spacing 1.4.
- Lề: trên 2.5 cm, dưới 2.5 cm, trái 3.5 cm, phải 2.0 cm.
- Công thức phải gõ bằng Equation Editor, LaTeX hoặc công cụ tương đương; không dùng ảnh chụp công thức.
- Hình minh họa trong phần lý thuyết phải tự vẽ lại hoặc tự tạo, không chụp trực tiếp từ nguồn ngoài.
- Nội dung không được sao chép nếu không trích dẫn hợp lệ.
- Mọi thành viên phải hiểu nội dung và trả lời được khi giáo viên hỏi.

## 3. Lịch nộp và vấn đáp từ file schedule

- Session A: nộp PDF vào Saturday, 23 May 2026; vấn đáp ngày 29 May 2026.
- Session B: nộp PDF vào Saturday, 30 May 2026; vấn đáp ngày 05 June 2026.
- Nộp file PDF trên LMS đúng mục `Report Class CC02 session A` hoặc `Report Class CC02 session B`.
- Hình thức oral examination là hỏi đáp, không yêu cầu slide presentation.
- Vắng mặt ở buổi vấn đáp hoặc không có nhóm được phân công sẽ bị điểm project là 0.

## 4. Cấu trúc báo cáo nên có

1. Trang bìa.
2. Mục lục.
3. Giới thiệu: động lực, mục tiêu, phạm vi.
4. Cơ sở lý thuyết: định nghĩa, định lý, ý nghĩa công thức.
5. Thuật toán hoặc mô hình toán học: các bước, cơ sở lý thuyết, độ phức tạp nếu phù hợp.
6. Kết quả và đánh giá: ví dụ, kết quả chạy chương trình, biểu đồ, phân tích.
7. Kết luận và hướng phát triển.
8. Tài liệu tham khảo.

## 5. Những câu hỏi vấn đáp rất dễ gặp

- Trò chơi tổng bằng 0 là gì?
- Vì sao ma trận payoff chỉ cần biểu diễn lợi ích của người chơi A?
- Hàng và cột trong ma trận biểu diễn điều gì?
- Chiến lược thuần khác chiến lược hỗn hợp như thế nào?
- Vì sao người chơi A dùng maximin?
- Vì sao người chơi B dùng minimax?
- Khi nào có điểm yên ngựa?
- Nếu `maximin = minimax` thì ý nghĩa là gì?
- Nếu không có điểm yên ngựa thì vì sao phải dùng chiến lược hỗn hợp?
- Định lý minimax nói gì trong trò chơi hai người tổng bằng 0?
- Giá trị trò chơi `v` có ý nghĩa gì?
- Vì sao payoff kỳ vọng là `x^T A y`?
- Vector `x` và `y` phải thỏa điều kiện gì để là phân phối xác suất?
- Vì sao bài toán chiến lược hỗn hợp có thể đưa về quy hoạch tuyến tính?
- Trong code MATLAB, vì sao phải dịch ma trận bằng `shiftValue`?
- Việc cộng cùng một hằng số vào mọi phần tử payoff có làm đổi chiến lược tối ưu không?
- `linprog` đang giải bài toán nào?
- Vì sao nghiệm `x` và `y` từ `linprog` phải chuẩn hóa?
- `gameValue` và `expectedValue` khác nhau thế nào?
- Nếu có sai số nhỏ giữa `gameValue` và `expectedValue` thì giải thích ra sao?
- Code hiện tại có ưu điểm và hạn chế gì?

## 6. Những điểm cần nhấn mạnh khi bảo vệ code MATLAB

- Giao diện giúp nhập ma trận `N x M`, không chỉ `2 x 2`.
- Hàm `mainGameSolver(A)` là lõi thuật toán.
- Chương trình tính `rowMin`, `maximin`, `colMax`, `minimax` để kiểm tra saddle point.
- Chương trình dùng `linprog` để tìm chiến lược hỗn hợp tối ưu.
- Chương trình dùng `Ashift = A + shiftValue` để đưa payoff về dương trước khi lập LP.
- Chiến lược A và B được chuẩn hóa để tổng xác suất bằng 1.
- Giá trị kỳ vọng được tính trực tiếp trên ma trận gốc bằng `strategyA' * A * strategyB`.
- Biểu đồ cột thể hiện xác suất chọn chiến lược, heatmap thể hiện cấu trúc payoff.

## 7. Hạn chế nên tự nêu nếu giáo viên hỏi

- Code vẫn chạy `linprog` ngay cả khi đã có saddle point; có thể tối ưu bằng cách dừng sớm.
- So sánh `maximin == minimax` nên thay bằng so sánh có ngưỡng sai số `tol`.
- Chưa kiểm tra `NaN`, `Inf` hoặc dữ liệu không hợp lệ.
- Chưa đọc `exitflag` của `linprog`, nên chưa phân biệt rõ tối ưu, vô nghiệm hoặc không hội tụ.
- Chưa hiển thị vị trí saddle point nếu tồn tại.
- Phần heatmap dùng chữ trắng cố định nên có thể khó đọc ở nền sáng.

## 8. Checklist tự kiểm trước khi nộp

- Báo cáo có giải thích đủ pure strategy, mixed strategy, saddle point, maximin, minimax, minimax theorem.
- Có mô hình payoff matrix và giải thích ý nghĩa `a_ij`.
- Có công thức `x^T A y` và giải thích ý nghĩa xác suất.
- Có mô hình LP cho người chơi A và người chơi B.
- Có thuật toán `2 x 2` và thuật toán `N x M`.
- Có ít nhất 3 tình huống thực tế được phân tích sâu, không chỉ tính toán.
- Có hình/bảng/biểu đồ tự tạo.
- Có kết quả chạy MATLAB.
- Có giải thích các hàm chính trong code.
- Có tài liệu tham khảo đúng định dạng.
