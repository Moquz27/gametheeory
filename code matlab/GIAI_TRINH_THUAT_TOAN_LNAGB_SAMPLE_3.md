# Giải trình thuật toán và giải thích code `LNAGB_SAMPLE_3.m`

## 1. Mục đích của chương trình

File `LNAGB_SAMPLE_3.m` xây dựng một chương trình MATLAB có giao diện đồ họa để giải bài toán trò chơi ma trận tổng bằng 0 (zero-sum matrix game) giữa hai người chơi:

- Người chơi A chọn theo hàng của ma trận.
- Người chơi B chọn theo cột của ma trận.
- Ma trận payoff `A` biểu diễn lợi ích của người chơi A.
- Vì là trò chơi tổng bằng 0 nên phần lợi ích của B chính là đối nghịch với A.

Chương trình hỗ trợ:

- Nhập kích thước ma trận `N x M`.
- Nhập các phần tử payoff.
- Tính `maximin`, `minimax`.
- Kiểm tra điểm yên ngựa (saddle point).
- Tìm chiến lược hỗn hợp tối ưu cho hai người chơi bằng `linprog`.
- Hiển thị kết quả ra giao diện.
- Vẽ biểu đồ chiến lược và heatmap ma trận payoff.

## 2. Ý tưởng thuật toán tổng quát

Bài toán được giải theo hai bước chính:

1. Phân tích ma trận để tìm `maximin` và `minimax`.
2. Nếu chưa có nghiệm thuần rõ ràng, chuyển bài toán sang quy hoạch tuyến tính để tìm chiến lược hỗn hợp tối ưu.

Ý tưởng toán học:

- Với người chơi A, ta cần tìm phân phối xác suất `x` sao cho giá trị đảm bảo nhỏ nhất của A là lớn nhất.
- Với người chơi B, ta cần tìm phân phối xác suất `y` sao cho giá trị mà A nhận được là nhỏ nhất.
- Đây là cặp bài toán đối ngẫu trong quy hoạch tuyến tính.

Do `linprog` làm việc thuận lợi hơn khi các giá trị đảm bảo dương, chương trình tịnh tiến toàn bộ ma trận bằng:

`Ashift = A + shiftValue`

trong đó:

`shiftValue = abs(min(A(:))) + 1`

Việc cộng thêm một hằng số vào mọi phần tử không làm thay đổi chiến lược tối ưu, chỉ làm dịch giá trị trò chơi.

## 3. Cấu trúc chương trình

File gồm 3 phần chính:

1. Hàm giao diện `LNAGB_SAMPLE_3()`.
2. Hàm giải thuật `mainGameSolver(A)`.
3. Hàm trực quan hóa `plotStrategies(result)`.

## 4. Giải thích chi tiết từng phần code

## 4.1. Hàm chính `LNAGB_SAMPLE_3()`

### a. Khởi tạo môi trường

Ở đầu file:

```matlab
clc;
clear;
```

Tác dụng:

- `clc` xóa cửa sổ lệnh.
- `clear` xóa biến trong workspace.

Điểm cần lưu ý:

- Cách này phù hợp khi chạy độc lập trong MATLAB.
- Tuy nhiên nếu dùng trong môi trường lớn hơn hoặc tích hợp vào dự án khác thì `clear` có thể gây xóa các biến không mong muốn.

### b. Tạo giao diện đồ họa

```matlab
fig = uifigure('Name','NxM Matrix Game Solver','Position',[100 100 1200 720]);
```

Lệnh này tạo cửa sổ chính của ứng dụng.

Sau đó chương trình tạo:

- Tiêu đề giao diện.
- Ô nhập số hàng cho người chơi A.
- Ô nhập số cột cho người chơi B.
- Nút tạo ma trận.
- Nút giải bài toán.
- Nút hiển thị biểu đồ.
- Bảng nhập dữ liệu ma trận.
- Vùng văn bản hiển thị kết quả.

### c. Biến lưu kết quả hiện tại

```matlab
currentResult = [];
```

Biến này dùng để lưu nghiệm vừa giải xong. Nếu người dùng bấm `Show Charts` trước khi giải thì chương trình sẽ kiểm tra biến này để tránh lỗi.

## 4.2. Callback `createMatrix()`

Mục tiêu của hàm con này là đọc kích thước từ giao diện rồi tạo bảng nhập ma trận mới.

### Luồng xử lý

1. Đọc số hàng:

```matlab
rows = round(rowField.Value);
```

2. Đọc số cột:

```matlab
cols = round(colField.Value);
```

3. Kiểm tra điều kiện:

```matlab
if rows < 2 || cols < 2
    uialert(fig,'Matrix must be at least 2x2.','Invalid Size');
    return;
end
```

4. Nếu hợp lệ, tạo ma trận 0 kích thước `rows x cols`:

```matlab
matrixTable.Data = zeros(rows,cols);
```

### Ý nghĩa

Hàm này không giải bài toán mà chỉ chuẩn bị vùng nhập dữ liệu để người dùng điền payoff.

## 4.3. Callback `solveGame()`

Đây là phần nối giao diện với thuật toán.

### Luồng xử lý

1. Lấy ma trận payoff từ bảng:

```matlab
A = matrixTable.Data;
```

2. Gọi hàm giải:

```matlab
currentResult = mainGameSolver(A);
```

3. Dựng chuỗi hiển thị ma trận theo từng hàng để kết quả dễ đọc.

4. Ghép các thông tin đầu ra:

- Ma trận payoff.
- `maximin`.
- `minimax`.
- Có hay không điểm yên ngựa.
- Chiến lược hỗn hợp của A.
- Chiến lược hỗn hợp của B.
- Giá trị trò chơi.
- Kỳ vọng payoff `x^T A y`.

5. Hiển thị vào `resultText`.

6. Nếu xảy ra lỗi thì hiển thị thông báo lỗi:

```matlab
catch ME
    resultText.Value = ME.message;
end
```

### Vai trò

Phần này giúp người dùng không cần thao tác dòng lệnh, chỉ cần nhập ma trận và bấm nút để giải.

## 4.4. Callback `showCharts()`

Hàm này dùng để vẽ biểu đồ sau khi đã có nghiệm.

### Cách hoạt động

1. Kiểm tra đã có kết quả chưa:

```matlab
if isempty(currentResult)
    uialert(fig,'Solve the game first.','No Data');
    return;
end
```

2. Nếu đã có nghiệm thì gọi:

```matlab
plotStrategies(currentResult);
```

## 4.5. Hàm giải thuật `mainGameSolver(A)`

Đây là phần quan trọng nhất của toàn bộ chương trình.

### Bước 1. Lấy kích thước ma trận

```matlab
[m,n] = size(A);
```

Trong đó:

- `m` là số chiến lược của A.
- `n` là số chiến lược của B.

### Bước 2. Tính `maximin`

```matlab
rowMin = min(A, [], 2);
maximin = max(rowMin);
```

Giải thích:

- Với mỗi hàng, lấy phần tử nhỏ nhất vì nếu A chọn hàng đó thì B sẽ cố làm A nhận ít nhất có thể.
- Trong các giá trị nhỏ nhất đó, A chọn giá trị lớn nhất để đảm bảo lợi ích tối thiểu tốt nhất.

Ý nghĩa:

`maximin` là mức lợi ích đảm bảo mà A có thể chắc chắn đạt được nếu chơi tối ưu theo nghĩa phòng thủ.

### Bước 3. Tính `minimax`

```matlab
colMax = max(A, [], 1);
minimax = min(colMax);
```

Giải thích:

- Với mỗi cột, lấy phần tử lớn nhất vì nếu B chọn cột đó thì A có thể tận dụng để nhận mức cao nhất trên cột ấy.
- B sẽ chọn cột làm cho giá trị lớn nhất đó là nhỏ nhất.

Ý nghĩa:

`minimax` là ngưỡng mà B có thể ép A không vượt quá nếu B chơi tối ưu.

### Bước 4. Kiểm tra điểm yên ngựa

```matlab
if maximin == minimax
    result.hasSaddle = true;
    result.gameValue = maximin;
else
    result.hasSaddle = false;
end
```

Nếu `maximin = minimax` thì trò chơi có nghiệm thuần.

Khi đó:

- Hai người chơi có thể dùng chiến lược thuần.
- Giá trị trò chơi bằng đúng giá trị đó.

Lưu ý:

- Mã nguồn vẫn tiếp tục chạy phần quy hoạch tuyến tính ngay cả khi đã có saddle point.
- Điều này không sai về mặt ý tưởng tổng quát, nhưng là chưa tối ưu về hiệu năng và làm dư bước tính toán.

### Bước 5. Tịnh tiến ma trận để tránh giá trị âm

```matlab
shiftValue = abs(min(A(:))) + 1;
Ashift = A + shiftValue;
```

Ý nghĩa:

- Nếu ma trận có số âm hoặc số 0, thuật toán chuyển toàn bộ phần tử sang dương.
- Điều này giúp mô hình quy hoạch tuyến tính ở dạng đang dùng vận hành ổn định hơn.

Ví dụ:

- Nếu phần tử nhỏ nhất của `A` là `-4` thì `shiftValue = 5`.
- Khi đó mọi phần tử của `Ashift` sẽ lớn hơn hoặc bằng `1`.

### Bước 6. Lập quy hoạch tuyến tính cho người chơi A

Mã nguồn:

```matlab
fA = ones(m,1);
AA = -Ashift';
bA = -ones(n,1);
lbA = zeros(m,1);
x = linprog(fA,AA,bA,[],[],lbA);
```

Diễn giải:

- Biến quyết định là vector `x` kích thước `m x 1`.
- Mục tiêu là tối thiểu `sum(x)`.
- Ràng buộc tương đương với việc bảo đảm mọi cột đều cho giá trị ít nhất bằng 1 sau biến đổi chuẩn hóa.
- `lbA = 0` buộc các thành phần không âm.

Sau khi giải:

```matlab
valueA = 1 / sum(x);
strategyA = x * valueA;
```

Giải thích:

- `x` ban đầu chưa phải xác suất.
- Nhân với `valueA = 1/sum(x)` để chuẩn hóa tổng bằng 1.
- Khi đó `strategyA` là phân phối xác suất trên các hàng.

### Bước 7. Lập quy hoạch tuyến tính cho người chơi B

Mã nguồn:

```matlab
fB = ones(n,1);
AB = -Ashift;
bB = -ones(m,1);
lbB = zeros(n,1);
y = linprog(fB,AB,bB,[],[],lbB);
```

Sau đó chuẩn hóa:

```matlab
valueB = 1 / sum(y);
strategyB = y * valueB;
```

Ý nghĩa:

- `strategyB` là phân phối xác suất trên các cột.
- Đây là bài toán đối ngẫu với bài toán của A.

### Bước 8. Tính giá trị trò chơi

```matlab
v = ((valueA + valueB)/2) - shiftValue;
```

Giải thích:

- Về lý thuyết, trong bài toán giải chính xác, `valueA` và `valueB` phải rất gần nhau.
- Chương trình lấy trung bình của hai giá trị rồi trừ phần đã dịch `shiftValue`.
- Cách này giúp giảm sai lệch nhỏ do sai số số học khi giải quy hoạch tuyến tính.

### Bước 9. Tính kỳ vọng payoff

```matlab
expectedValue = strategyA' * A * strategyB;
```

Ý nghĩa:

- Đây là giá trị kỳ vọng đúng theo ma trận gốc.
- Nếu thuật toán chính xác thì giá trị này phải rất gần `gameValue`.

### Bước 10. Lưu kết quả

Kết quả được đưa vào struct `result` gồm:

- `maximin`
- `minimax`
- `hasSaddle`
- `strategyA`
- `strategyB`
- `gameValue`
- `expectedValue`
- `matrix`

## 4.6. Hàm `plotStrategies(result)`

Hàm này vẽ 3 biểu đồ:

1. Biểu đồ cột cho chiến lược hỗn hợp của A.
2. Biểu đồ cột cho chiến lược hỗn hợp của B.
3. Heatmap của ma trận payoff.

### Ý nghĩa trực quan

- Nếu một cột có xác suất bằng 0 thì chiến lược đó không được chọn trong nghiệm tối ưu.
- Heatmap giúp người dùng nhìn nhanh vùng payoff lớn nhỏ trong ma trận.

### Cách hiển thị heatmap

```matlab
imagesc(result.matrix);
colorbar;
```

Sau đó chương trình chèn số trực tiếp lên từng ô:

```matlab
text(x(:),y(:),textStrings(:),...)
```

Việc này giúp heatmap không chỉ có màu mà còn có cả giá trị cụ thể.

## 5. Luồng hoạt động tổng thể của chương trình

1. Người dùng chạy `LNAGB_SAMPLE_3`.
2. Giao diện hiện ra với kích thước mặc định `3 x 3`.
3. Người dùng nhập số hàng và số cột.
4. Nhấn `Create Matrix` để tạo bảng đúng kích thước.
5. Nhập payoff matrix.
6. Nhấn `Solve Game`.
7. Chương trình tính:

- `maximin`
- `minimax`
- kiểm tra saddle point
- chiến lược hỗn hợp tối ưu
- giá trị trò chơi
- payoff kỳ vọng

8. Kết quả hiển thị trong ô văn bản.
9. Người dùng có thể nhấn `Show Charts` để xem biểu đồ.

## 6. Ý nghĩa học thuật của thuật toán

Chương trình thể hiện đúng tinh thần của định lý minimax trong trò chơi tổng bằng 0:

- Người chơi A cố tối đa hóa mức lợi ích được đảm bảo.
- Người chơi B cố tối thiểu hóa lợi ích của A.
- Khi dùng chiến lược hỗn hợp, bài toán có thể đưa về quy hoạch tuyến tính.

Đây là một cách tiếp cận kinh điển, rất phù hợp cho:

- bài tập môn lý thuyết trò chơi,
- minh họa định lý minimax,
- thực nghiệm với ma trận kích thước bất kỳ,
- so sánh nghiệm thuần và nghiệm hỗn hợp.

## 7. Ưu điểm của chương trình

- Có giao diện đồ họa nên dễ dùng với người không quen dòng lệnh.
- Hỗ trợ ma trận `N x M`, không bị giới hạn ở `2 x 2`.
- Có tính `maximin` và `minimax`, giúp giải thích bản chất trò chơi.
- Có kiểm tra saddle point.
- Dùng `linprog`, tức là áp dụng phương pháp chuẩn, rõ ràng về mặt toán học.
- Có trực quan hóa bằng biểu đồ xác suất và heatmap.
- Cấu trúc tách riêng phần giao diện, phần giải thuật và phần vẽ biểu đồ nên tương đối dễ đọc.

## 8. Nhược điểm của chương trình

- Chưa dừng sớm khi đã phát hiện saddle point, nên vẫn giải quy hoạch tuyến tính dù có thể không cần.
- So sánh `maximin == minimax` bằng số thực tuyệt đối, dễ gặp sai lệch nếu sau này dữ liệu hoặc tính toán phát sinh số thực có sai số.
- Chưa kiểm tra dữ liệu đầu vào có phải là số hữu hạn hay không, ví dụ `NaN`, `Inf`.
- Chưa xử lý rõ trạng thái hội tụ hay cờ trả về của `linprog`, hiện mới kiểm tra `isempty(x)` và `isempty(y)`.
- Chưa cố định tùy chọn solver, nên phụ thuộc thiết lập mặc định của MATLAB/Optimization Toolbox.
- Biến và chú thích còn pha trộn giữa tên khá rõ nghĩa và tên ngắn, làm mức nhất quán chưa cao.
- Chưa hiển thị trực tiếp vị trí điểm yên ngựa khi nó tồn tại.
- Màu chữ trên heatmap luôn là trắng nên có thể khó nhìn ở các ô màu sáng.
- Dùng `clear` trong hàm giao diện là hơi mạnh tay nếu xem đây là thành phần của một dự án lớn hơn.

## 9. Đề xuất sửa đổi và cải tiến

### a. Dừng sớm khi có saddle point

Khi `maximin` và `minimax` bằng nhau, có thể:

- xác định luôn chiến lược thuần tương ứng,
- trả kết quả ngay,
- bỏ qua bước `linprog`.

Lợi ích:

- giảm thời gian tính,
- đơn giản hơn về logic,
- tránh tính toán dư thừa.

### b. So sánh số thực bằng ngưỡng sai số

Thay vì:

```matlab
if maximin == minimax
```

nên dùng ý tưởng:

```matlab
if abs(maximin - minimax) < tol
```

với `tol` nhỏ như `1e-8`.

Lợi ích:

- an toàn hơn với số thực,
- bền vững hơn khi mở rộng chương trình.

### c. Kiểm tra đầu vào chặt hơn

Nên kiểm tra:

- ma trận có rỗng không,
- có phần tử `NaN` hay `Inf` không,
- có phải toàn số thực không.

Lợi ích:

- tránh lỗi solver,
- thông báo cho người dùng rõ ràng hơn.

### d. Kiểm tra trạng thái trả về của `linprog`

Nên lấy thêm:

```matlab
[x, fval, exitflag, output] = linprog(...)
```

và kiểm tra `exitflag`.

Lợi ích:

- phân biệt được nghiệm tối ưu, vô nghiệm, không hội tụ, hay lỗi số học.

### e. Chuẩn hóa hiển thị kết quả

Nên:

- định dạng số với số chữ số thập phân hợp lý,
- hiển thị tổng xác suất của mỗi chiến lược để kiểm chứng bằng 1,
- hiển thị sai số `abs(gameValue - expectedValue)`.

Lợi ích:

- người dùng dễ kiểm tra tính đúng đắn hơn.

### f. Cải thiện heatmap

Nên chọn màu chữ động:

- nền tối thì chữ trắng,
- nền sáng thì chữ đen.

Lợi ích:

- tăng khả năng đọc biểu đồ.

### g. Tổ chức lại mã nguồn

Nên tách file thành:

- một file giao diện,
- một file solver,
- một file tiện ích vẽ biểu đồ.

Lợi ích:

- dễ bảo trì,
- dễ kiểm thử,
- dễ tái sử dụng solver mà không phụ thuộc GUI.

## 10. Kết luận

`LNAGB_SAMPLE_3.m` là một chương trình có ý tưởng tốt và đúng hướng cho bài toán trò chơi ma trận tổng bằng 0. Điểm mạnh lớn nhất là kết hợp được:

- giao diện nhập liệu,
- phân tích `maximin` và `minimax`,
- giải chiến lược hỗn hợp bằng quy hoạch tuyến tính,
- trực quan hóa kết quả.

Về bản chất thuật toán, chương trình đang áp dụng phương pháp kinh điển và phù hợp về mặt lý thuyết. Tuy nhiên, nếu muốn nâng chất lượng từ mức minh họa học thuật lên mức công cụ ổn định hơn, nên bổ sung kiểm tra đầu vào, xử lý trạng thái solver, so sánh số thực bằng ngưỡng sai số, và dừng sớm khi đã có saddle point.

