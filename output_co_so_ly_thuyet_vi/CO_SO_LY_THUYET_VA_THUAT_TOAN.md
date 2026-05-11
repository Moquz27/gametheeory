# Cơ sở lý thuyết và thuật toán cần hiểu cho project

## 0. Bức tranh tổng thể của project

Project thuộc chủ đề **Applications of Matrices in Game Theory**, tập trung vào trò chơi ma trận hai người tổng bằng 0. Nói ngắn gọn, ta có hai người chơi:

- Người chơi A chọn một hàng của ma trận.
- Người chơi B chọn một cột của ma trận.
- Phần tử `a_ij` là lợi ích của A khi A chọn hàng `i` và B chọn cột `j`.
- Vì trò chơi tổng bằng 0, lợi ích của B là `-a_ij`.

Mục tiêu học thuật của project không chỉ là viết code giải ma trận, mà là hiểu:

- Vì sao trò chơi được biểu diễn bằng ma trận.
- Khi nào có nghiệm chiến lược thuần.
- Khi nào phải dùng chiến lược hỗn hợp.
- Vì sao nghiệm hỗn hợp liên quan tới định lý minimax.
- Vì sao bài toán có thể chuyển thành quy hoạch tuyến tính.
- Code MATLAB đang hiện thực hóa các bước toán học đó như thế nào.

Code `LNAGB_SAMPLE_3.m` hiện tại làm đúng hướng này: nhập ma trận payoff, tính `maximin`, `minimax`, kiểm tra saddle point, dùng `linprog` để tìm chiến lược hỗn hợp tối ưu, tính giá trị trò chơi và trực quan hóa kết quả.

## 1. Danh mục kiến thức từ cơ bản đến nâng cao

### Mức 1: Nền tảng ma trận và mô hình trò chơi

1. Ma trận payoff.
2. Ý nghĩa hàng, cột và phần tử `a_ij`.
3. Trò chơi hai người.
4. Trò chơi tổng bằng 0.
5. Chiến lược thuần.
6. Kết quả và payoff.

### Mức 2: Phân tích nghiệm thuần

1. Tư duy đối kháng giữa A và B.
2. Row minimum.
3. Column maximum.
4. Maximin.
5. Minimax.
6. Điểm yên ngựa.
7. Giá trị trò chơi khi có saddle point.

### Mức 3: Chiến lược hỗn hợp và kỳ vọng

1. Phân phối xác suất trên tập chiến lược.
2. Vector chiến lược hỗn hợp `x` của A.
3. Vector chiến lược hỗn hợp `y` của B.
4. Điều kiện xác suất: không âm và tổng bằng 1.
5. Payoff kỳ vọng `x^T A y`.
6. Giá trị trò chơi khi không có saddle point.
7. Ý nghĩa cân bằng trong trò chơi zero-sum.

### Mức 4: Định lý minimax

1. Phát biểu trực giác của định lý minimax.
2. Công thức `max_x min_y x^T A y = min_y max_x x^T A y`.
3. Ý nghĩa: chiến lược tối ưu tồn tại trong mixed strategies.
4. Vai trò của định lý trong việc bảo đảm bài toán có nghiệm.

### Mức 5: Thuật toán giải trò chơi ma trận

1. Thuật toán kiểm tra saddle point.
2. Thuật toán giải trò chơi `2 x 2`.
3. Thuật toán tổng quát cho ma trận `N x M`.
4. Xử lý payoff âm bằng cách dịch ma trận.
5. Chuẩn hóa nghiệm để tạo phân phối xác suất.
6. Kiểm tra kết quả bằng payoff kỳ vọng.

### Mức 6: Quy hoạch tuyến tính

1. Biến quyết định.
2. Hàm mục tiêu tuyến tính.
3. Ràng buộc tuyến tính.
4. Điều kiện không âm.
5. Bài toán LP của người chơi A.
6. Bài toán LP của người chơi B.
7. Đối ngẫu giữa hai bài toán.
8. Liên hệ với `linprog` trong MATLAB.

### Mức 7: Ứng dụng và phân tích thực tế

1. Cách biến một tình huống thực tế thành game matrix.
2. Xác định người chơi, chiến lược, payoff.
3. Giải thích giả định mô hình.
4. Diễn giải từng phần tử ma trận.
5. Diễn giải ý nghĩa chiến lược tối ưu.
6. Phân tích kinh tế hoặc xã hội, không chỉ tính toán.

## 2. Ma trận payoff

Ma trận payoff là trung tâm của project. Với trò chơi có `m` chiến lược của A và `n` chiến lược của B, ta viết:

```text
A = [a_ij], i = 1,...,m; j = 1,...,n
```

Trong đó:

- `i` là chiến lược/hàng của A.
- `j` là chiến lược/cột của B.
- `a_ij` là payoff của A khi cặp chiến lược `(i, j)` xảy ra.
- Vì tổng bằng 0, payoff của B là `-a_ij`.

Ví dụ:

```text
          B1    B2    B3
A1        2    -1     4
A2        0     3    -2
A3        1     2     1
```

Nếu A chọn `A2` và B chọn `B3`, payoff của A là `-2`, tức A mất 2 đơn vị lợi ích, còn B được 2 đơn vị lợi ích.

Điểm quan trọng khi viết báo cáo: `a_ij` không nhất thiết phải là tiền. Nó có thể là lợi nhuận, điểm số, lợi thế chiến lược, mức thiệt hại tránh được, thị phần, hoặc một chỉ số tổng hợp. Miễn là nó đo lợi ích của A và lợi ích của B là đối nghịch.

## 3. Trò chơi hai người tổng bằng 0

Trò chơi tổng bằng 0 là tình huống mà lợi ích của một bên đúng bằng thiệt hại của bên kia. Nếu A nhận `a_ij`, B nhận `-a_ij`, nên tổng payoff là:

```text
a_ij + (-a_ij) = 0
```

Đây là mô hình phù hợp cho các tình huống cạnh tranh trực tiếp:

- Hai công ty tranh giành thị phần tương đối.
- Đội phòng thủ và đội tấn công trong an ninh mạng.
- Người kiểm tra chất lượng và bên cố che giấu lỗi.
- Hai chiến lược đầu tư đối nghịch trong một thị trường đơn giản hóa.

Lưu ý quan trọng: không phải mọi bài toán thực tế đều là zero-sum. Nếu hai bên có thể cùng thắng hoặc cùng thua thì mô hình zero-sum là đơn giản hóa. Trong báo cáo, khi đưa tình huống thực tế, cần nêu giả định rõ: ta đang xét lợi ích tương đối, hoặc quy đổi payoff sao cho lợi ích của A đối nghịch lợi ích của B.

## 4. Chiến lược thuần

Chiến lược thuần là việc người chơi chọn chắc chắn một chiến lược cụ thể.

Nếu A có `m` hàng, chiến lược thuần của A là chọn một hàng `i`. Nếu B có `n` cột, chiến lược thuần của B là chọn một cột `j`.

Ví dụ:

- A chọn hàng 2 với xác suất 100%.
- B chọn cột 1 với xác suất 100%.

Chiến lược thuần dễ hiểu và dễ tính, nhưng không phải lúc nào cũng tối ưu. Trong nhiều trò chơi đối kháng, nếu một người luôn chọn một chiến lược cố định, đối thủ có thể đoán được và khai thác.

## 5. Row minimum, maximin và tư duy của người chơi A

Người chơi A muốn tối đa hóa payoff của mình. Nhưng vì B là đối thủ, A phải tính đến trường hợp B phản ứng bất lợi nhất.

Với một hàng `i`, nếu A chọn hàng đó, B sẽ chọn cột làm payoff của A nhỏ nhất trên hàng đó. Vì vậy ta xét:

```text
rowMin_i = min_j a_ij
```

Sau đó A chọn hàng có giá trị đảm bảo lớn nhất:

```text
maximin = max_i min_j a_ij
```

Ý nghĩa:

- `min_j a_ij` là mức A chắc chắn nhận được nếu chọn hàng `i`, dù B chọn cột bất lợi nhất.
- `max_i min_j a_ij` là mức đảm bảo tốt nhất mà A có thể tự bảo vệ.

Trong code MATLAB:

```matlab
rowMin = min(A, [], 2);
maximin = max(rowMin);
```

`min(A, [], 2)` lấy min theo từng hàng. Sau đó `max(rowMin)` lấy mức đảm bảo lớn nhất.

## 6. Column maximum, minimax và tư duy của người chơi B

B muốn làm payoff của A càng nhỏ càng tốt. Nếu B chọn một cột `j`, A có thể phản ứng bằng hàng làm payoff cao nhất trên cột đó. Vì vậy B nhìn vào:

```text
colMax_j = max_i a_ij
```

Sau đó B chọn cột có giá trị tối đa nhỏ nhất:

```text
minimax = min_j max_i a_ij
```

Ý nghĩa:

- `max_i a_ij` là mức payoff cao nhất mà A có thể đạt nếu B chọn cột `j`.
- `min_j max_i a_ij` là mức trần thấp nhất mà B có thể ép A không vượt quá.

Trong code MATLAB:

```matlab
colMax = max(A, [], 1);
minimax = min(colMax);
```

`max(A, [], 1)` lấy max theo từng cột. Sau đó `min(colMax)` lấy cột an toàn nhất cho B.

## 7. Điểm yên ngựa

Điểm yên ngựa, hay saddle point, tồn tại khi:

```text
maximin = minimax
```

Nếu điều này xảy ra, trò chơi có nghiệm chiến lược thuần. Giá trị chung đó là giá trị trò chơi:

```text
v = maximin = minimax
```

Diễn giải:

- A có thể đảm bảo ít nhất `v`.
- B có thể ép A nhiều nhất chỉ nhận `v`.
- Không bên nào có lợi khi đơn phương đổi chiến lược nếu bên kia giữ chiến lược tại saddle point.

Một phần tử `a_ij` là saddle point nếu nó đồng thời là:

- Nhỏ nhất trên hàng của nó.
- Lớn nhất trên cột của nó.

Trong code MATLAB:

```matlab
if maximin == minimax
    result.hasSaddle = true;
    result.gameValue = maximin;
else
    result.hasSaddle = false;
end
```

Điểm cần hiểu để bảo vệ: code hiện chỉ kiểm tra có saddle point bằng giá trị, nhưng chưa chỉ ra vị trí cụ thể `(i, j)` của saddle point. Nếu giáo viên hỏi cải tiến, có thể đề xuất tìm các ô thỏa `A(i,j) == rowMin(i)` và `A(i,j) == colMax(j)`.

## 8. Vì sao cần chiến lược hỗn hợp

Nếu không có saddle point, chiến lược thuần không đủ ổn định. Một người chơi chọn cố định một hàng/cột có thể bị đối thủ khai thác.

Chiến lược hỗn hợp là phân phối xác suất trên các chiến lược thuần.

Với A:

```text
x = [x_1, x_2, ..., x_m]^T
```

Trong đó:

```text
x_i >= 0
x_1 + x_2 + ... + x_m = 1
```

Với B:

```text
y = [y_1, y_2, ..., y_n]^T
```

Trong đó:

```text
y_j >= 0
y_1 + y_2 + ... + y_n = 1
```

Nếu `x_2 = 0.4`, nghĩa là A chọn hàng 2 với xác suất 40%. Nếu `y_3 = 0`, nghĩa là B không dùng cột 3 trong chiến lược tối ưu.

Ý nghĩa thực tế: chiến lược hỗn hợp giúp người chơi không bị đoán trước. Nó cũng giúp cân bằng rủi ro khi không có một chiến lược thuần nào luôn tốt.

## 9. Payoff kỳ vọng `x^T A y`

Khi A dùng chiến lược hỗn hợp `x` và B dùng `y`, payoff không còn là một phần tử đơn lẻ `a_ij`, mà là giá trị kỳ vọng:

```text
E = x^T A y
```

Viết rõ hơn:

```text
E = sum_i sum_j x_i a_ij y_j
```

Diễn giải:

- `x_i` là xác suất A chọn hàng `i`.
- `y_j` là xác suất B chọn cột `j`.
- `x_i y_j` là xác suất cặp `(i, j)` xảy ra nếu hai bên chọn độc lập.
- `a_ij` là payoff khi cặp đó xảy ra.
- Tổng tất cả `x_i a_ij y_j` là payoff trung bình dài hạn của A.

Trong code MATLAB:

```matlab
expectedValue = strategyA' * A * strategyB;
```

Đây là công thức kiểm chứng rất quan trọng. Nếu thuật toán giải đúng, `expectedValue` phải gần với `gameValue`. Sai khác nhỏ có thể do sai số số học của solver.

## 10. Định lý minimax

Định lý minimax là nền tảng lý thuyết quan trọng nhất của project. Với trò chơi hai người tổng bằng 0 hữu hạn, định lý nói rằng:

```text
max_x min_y x^T A y = min_y max_x x^T A y
```

Trong đó `x` và `y` là các chiến lược hỗn hợp hợp lệ.

Vế trái:

- A chọn chiến lược hỗn hợp để tối đa hóa payoff được đảm bảo trong tình huống B phản ứng bất lợi nhất.

Vế phải:

- B chọn chiến lược hỗn hợp để tối thiểu hóa mức payoff cao nhất mà A có thể đạt.

Ý nghĩa:

- Hai giá trị này bằng nhau.
- Tồn tại giá trị trò chơi `v`.
- Tồn tại chiến lược hỗn hợp tối ưu cho A và B.
- Nếu không có saddle point trong chiến lược thuần, vẫn có nghiệm trong chiến lược hỗn hợp.

Đây là lý do project không dừng ở maximin/minimax thuần, mà cần dùng quy hoạch tuyến tính để tìm mixed strategies.

## 11. Giá trị trò chơi

Giá trị trò chơi `v` là payoff kỳ vọng của A khi cả hai bên chơi tối ưu.

- Nếu `v > 0`, trò chơi có lợi thế kỳ vọng cho A.
- Nếu `v < 0`, trò chơi có lợi thế kỳ vọng cho B.
- Nếu `v = 0`, trò chơi cân bằng theo nghĩa kỳ vọng.

Trong chiến lược tối ưu:

```text
x*^T A y >= v với mọi y
x^T A y* <= v với mọi x
```

Nghĩa là:

- Nếu A dùng `x*`, A đảm bảo ít nhất `v` dù B chọn gì.
- Nếu B dùng `y*`, B giữ payoff của A không vượt quá `v` dù A chọn gì.

## 12. Thuật toán kiểm tra saddle point

Thuật toán cơ bản:

1. Nhập ma trận payoff `A`.
2. Tính min từng hàng: `rowMin_i = min_j a_ij`.
3. Tính `maximin = max_i rowMin_i`.
4. Tính max từng cột: `colMax_j = max_i a_ij`.
5. Tính `minimax = min_j colMax_j`.
6. Nếu `maximin = minimax`, có saddle point và `v = maximin`.
7. Nếu không, chuyển sang chiến lược hỗn hợp.

Độ phức tạp:

```text
O(mn)
```

Vì cần quét toàn bộ ma trận để tìm min theo hàng và max theo cột.

## 13. Thuật toán giải trò chơi `2 x 2`

Với ma trận:

```text
        B1     B2
A1      a      b
A2      c      d
```

Giả sử không có saddle point và nghiệm hỗn hợp nằm bên trong, A chọn hàng 1 với xác suất `p`, hàng 2 với xác suất `1 - p`. B chọn cột 1 với xác suất `q`, cột 2 với xác suất `1 - q`.

### Tìm chiến lược tối ưu của A

A chọn `p` sao cho B bàng quan giữa hai cột. Payoff của A nếu B chọn:

```text
B1: pa + (1-p)c
B2: pb + (1-p)d
```

Cho hai biểu thức bằng nhau:

```text
pa + (1-p)c = pb + (1-p)d
```

Giải ra:

```text
p = (d - c) / (a - b - c + d)
```

### Tìm chiến lược tối ưu của B

B chọn `q` sao cho A bàng quan giữa hai hàng. Payoff của A nếu A chọn:

```text
A1: qa + (1-q)b
A2: qc + (1-q)d
```

Cho hai biểu thức bằng nhau:

```text
qa + (1-q)b = qc + (1-q)d
```

Giải ra:

```text
q = (d - b) / (a - b - c + d)
```

### Giá trị trò chơi

Giá trị:

```text
v = (ad - bc) / (a - b - c + d)
```

Lưu ý:

- Công thức này chỉ dùng trực tiếp khi mẫu số khác 0 và nghiệm xác suất nằm trong `[0, 1]`.
- Nếu xác suất ra ngoài `[0, 1]`, nghiệm tối ưu có thể nằm ở biên hoặc đã có chiến lược bị trội.
- Với project có code giải `N x M`, công thức `2 x 2` nên trình bày như phần minh họa lý thuyết, còn thuật toán tổng quát nên dùng LP.

## 14. Chiến lược bị trội

Một chiến lược bị trội nếu luôn không tốt hơn một chiến lược khác.

Với A là người tối đa hóa:

- Hàng `r1` trội hơn hàng `r2` nếu mọi phần tử của `r1` đều lớn hơn hoặc bằng hàng `r2`, và có ít nhất một phần tử lớn hơn.
- Khi đó A không cần dùng `r2`.

Với B là người tối thiểu hóa payoff của A:

- Cột `c1` trội hơn cột `c2` đối với B nếu mọi phần tử của `c1` đều nhỏ hơn hoặc bằng cột `c2`, và có ít nhất một phần tử nhỏ hơn.
- Khi đó B không cần dùng `c2`.

Chiến lược bị trội không bắt buộc trong code hiện tại, nhưng là kiến thức tốt để giải thích thuật toán nâng cao. Loại bỏ chiến lược bị trội có thể giảm kích thước bài toán trước khi chạy LP.

## 15. Vì sao dùng quy hoạch tuyến tính

Khi ma trận lớn hơn `2 x 2`, công thức tay trở nên phức tạp. Nhưng bài toán vẫn có cấu trúc tuyến tính:

- Payoff kỳ vọng theo từng cột là tổ hợp tuyến tính của `x`.
- Payoff kỳ vọng theo từng hàng là tổ hợp tuyến tính của `y`.
- Điều kiện xác suất cũng tuyến tính.

Vì vậy có thể đưa bài toán tìm chiến lược hỗn hợp tối ưu thành quy hoạch tuyến tính.

Quy hoạch tuyến tính gồm:

- Biến quyết định.
- Hàm mục tiêu tuyến tính.
- Ràng buộc tuyến tính.
- Điều kiện biên, thường là không âm.

MATLAB giải bằng `linprog`.

## 16. Mô hình LP cho người chơi A

A muốn chọn `x` để tối đa hóa giá trị đảm bảo `v`:

```text
maximize v
subject to A^T x >= v 1
           sum_i x_i = 1
           x_i >= 0
```

Diễn giải:

- `A^T x` cho payoff kỳ vọng của A ứng với từng cột thuần của B.
- Ràng buộc `A^T x >= v 1` nghĩa là dù B chọn cột nào, A vẫn nhận ít nhất `v`.
- A muốn `v` càng lớn càng tốt.

Đây là dạng trực quan. Tuy nhiên code MATLAB dùng một dạng biến đổi khác để phù hợp với `linprog`.

## 17. Mô hình LP cho người chơi B

B muốn chọn `y` để tối thiểu hóa mức payoff cao nhất của A:

```text
minimize v
subject to A y <= v 1
           sum_j y_j = 1
           y_j >= 0
```

Diễn giải:

- `A y` cho payoff kỳ vọng của A ứng với từng hàng thuần của A.
- Ràng buộc `A y <= v 1` nghĩa là dù A chọn hàng nào, payoff của A không vượt quá `v`.
- B muốn `v` càng nhỏ càng tốt.

Hai mô hình của A và B là một cặp đối ngẫu trong quy hoạch tuyến tính. Theo lý thuyết đối ngẫu mạnh, giá trị tối ưu của hai bài toán bằng nhau, phù hợp với định lý minimax.

## 18. Vì sao code dịch ma trận payoff

Code MATLAB có đoạn:

```matlab
shiftValue = abs(min(A(:))) + 1;
Ashift = A + shiftValue;
```

Lý do: dạng LP chuẩn hóa đang dùng yêu cầu payoff dương để biến đổi `v` thành `1 / sum(x)` thuận lợi. Nếu ma trận có số âm hoặc 0, phép biến đổi có thể không hợp lệ hoặc gây khó diễn giải.

Khi cộng cùng một hằng số `c` vào mọi phần tử:

```text
Ashift = A + c
```

Payoff kỳ vọng mới là:

```text
x^T (A + cJ) y = x^T A y + c x^T J y
```

Vì `x` và `y` là phân phối xác suất:

```text
x^T J y = 1
```

Nên:

```text
x^T Ashift y = x^T A y + c
```

Điều này chỉ dịch giá trị trò chơi thêm `c`, không làm thay đổi chiến lược tối ưu. Vì vậy sau khi giải trên `Ashift`, code trừ lại `shiftValue` để quay về giá trị của ma trận gốc.

## 19. Dạng LP chuẩn hóa mà code đang dùng cho A

Sau khi dịch ma trận để các phần tử dương, code giải:

```matlab
fA = ones(m,1);
AA = -Ashift';
bA = -ones(n,1);
lbA = zeros(m,1);
x = linprog(fA, AA, bA, [], [], lbA);
```

`linprog` mặc định giải:

```text
minimize f^T z
subject to AA z <= b
           z >= lb
```

Với A, ràng buộc:

```text
-Ashift^T x <= -1
```

tương đương:

```text
Ashift^T x >= 1
```

Mục tiêu:

```text
minimize sum(x_i)
```

Sau khi có nghiệm `x`, code tính:

```matlab
valueA = 1 / sum(x);
strategyA = x * valueA;
```

Vì `valueA = 1 / sum(x)`, nên:

```text
sum(strategyA) = sum(x * valueA) = valueA * sum(x) = 1
```

Do đó `strategyA` là phân phối xác suất hợp lệ.

Trực giác: biến `x` trong LP chưa phải xác suất. Nó là biến đã được scale theo giá trị trò chơi. Chuẩn hóa lại sẽ cho xác suất thật.

## 20. Dạng LP chuẩn hóa mà code đang dùng cho B

Code giải:

```matlab
fB = ones(n,1);
AB = -Ashift;
bB = -ones(m,1);
lbB = zeros(n,1);
y = linprog(fB, AB, bB, [], [], lbB);
```

Ràng buộc:

```text
-Ashift y <= -1
```

tương đương:

```text
Ashift y >= 1
```

Sau đó:

```matlab
valueB = 1 / sum(y);
strategyB = y * valueB;
```

Về mặt lý thuyết, bài toán cho B thường được viết ở dạng đối ngẫu với điều kiện `A y <= v 1`. Code hiện tại dùng một dạng chuẩn hóa tương tự A trên ma trận đã dịch. Cách này có thể cho nghiệm trong nhiều ví dụ minh họa, nhưng khi giải thích học thuật nên trình bày mô hình chuẩn của B là:

```text
minimize v
subject to A y <= v 1
           sum(y) = 1
           y >= 0
```

Nếu muốn code chặt chẽ hơn theo giáo trình, nên viết LP cho B theo dạng đối ngẫu chuẩn hoặc kiểm chứng kỹ bằng `expectedValue`.

## 21. Tính giá trị trò chơi trong code

Code tính:

```matlab
v = ((valueA + valueB)/2) - shiftValue;
```

Về lý thuyết, nếu hai bài toán LP là đối ngẫu đúng và solver chính xác:

```text
valueA = valueB
```

Trong tính toán số, có thể lệch rất nhỏ. Code lấy trung bình để giảm sai lệch rồi trừ `shiftValue` để quay về ma trận gốc.

Sau đó code tính:

```matlab
expectedValue = strategyA' * A * strategyB;
```

Đây là giá trị kỳ vọng trực tiếp trên ma trận ban đầu. Khi bảo vệ, nên nói:

- `gameValue` là giá trị suy ra từ LP sau khi dịch ngược.
- `expectedValue` là kiểm chứng bằng công thức payoff kỳ vọng.
- Hai giá trị nên gần nhau nếu thuật toán và nghiệm đúng.

## 22. Thuật toán tổng quát `N x M` theo code MATLAB

Thuật toán trong `mainGameSolver(A)` có thể diễn giải như sau:

1. Nhận ma trận payoff `A`.
2. Lấy kích thước `m, n`.
3. Tính min từng hàng và `maximin`.
4. Tính max từng cột và `minimax`.
5. Kiểm tra `maximin == minimax` để xác định saddle point.
6. Dịch ma trận bằng `shiftValue = abs(min(A(:))) + 1`.
7. Giải LP cho người chơi A bằng `linprog`.
8. Chuẩn hóa nghiệm của A thành `strategyA`.
9. Giải LP cho người chơi B bằng `linprog`.
10. Chuẩn hóa nghiệm của B thành `strategyB`.
11. Tính giá trị trò chơi `gameValue`.
12. Tính payoff kỳ vọng `strategyA' * A * strategyB`.
13. Lưu kết quả vào struct `result`.
14. Giao diện hiển thị kết quả và vẽ biểu đồ.

Độ phức tạp:

- Phần kiểm tra saddle point: `O(mn)`.
- Phần LP phụ thuộc thuật toán nội bộ của `linprog`, số biến và số ràng buộc.
- Với A: có `m` biến và `n` ràng buộc bất đẳng thức.
- Với B: có `n` biến và `m` ràng buộc bất đẳng thức.

Trong báo cáo, chỉ cần nói độ phức tạp của LP phụ thuộc solver, nhưng kích thước bài toán tăng theo số chiến lược của hai người chơi.

## 23. Giao diện MATLAB và ý nghĩa các phần chính

File `LNAGB_SAMPLE_3.m` có ba phần:

### Giao diện `LNAGB_SAMPLE_3()`

Tạo cửa sổ nhập số hàng, số cột, bảng payoff, nút giải và nút vẽ biểu đồ.

### Solver `mainGameSolver(A)`

Là lõi toán học. Đây là phần cần hiểu sâu nhất khi bảo vệ.

### Trực quan hóa `plotStrategies(result)`

Vẽ:

- Bar chart chiến lược A.
- Bar chart chiến lược B.
- Heatmap ma trận payoff.

Ý nghĩa biểu đồ:

- Cột xác suất cao nghĩa là chiến lược đó được dùng nhiều trong nghiệm tối ưu.
- Xác suất 0 nghĩa là chiến lược đó không được dùng trong nghiệm tối ưu.
- Heatmap giúp nhìn cấu trúc payoff lớn/nhỏ trong ma trận.

## 24. Cách xây dựng tình huống ứng dụng thực tế

Yêu cầu giáo viên đòi ít nhất 3 tình huống ứng dụng, có phân tích sâu. Mỗi tình huống nên có cấu trúc:

1. Bối cảnh.
2. Hai người chơi là ai.
3. Tập chiến lược của A.
4. Tập chiến lược của B.
5. Ma trận payoff.
6. Giải thích từng `a_ij`.
7. Giả định mô hình.
8. Kết quả tối ưu.
9. Ý nghĩa chiến lược.
10. Phân tích kinh tế/xã hội.

Ví dụ các bối cảnh phù hợp:

- Doanh nghiệp A và doanh nghiệp B cạnh tranh giá/marketing.
- Đội an ninh mạng và hacker.
- Chính phủ và bên trốn thuế/gian lận.
- Nhà sản xuất và người kiểm định chất lượng.
- Đội bóng tấn công và đội bóng phòng thủ.

Điểm quan trọng: không chỉ đưa ma trận rồi bấm code. Phải giải thích tại sao payoff có giá trị đó, chiến lược tối ưu nói gì về hành vi thực tế, và giới hạn của mô hình là gì.

## 25. Mẫu tình huống 1: cạnh tranh marketing

Bối cảnh: Công ty A và đối thủ B cạnh tranh thị phần trong một chiến dịch ngắn hạn.

Chiến lược của A:

- `A1`: giảm giá.
- `A2`: tăng quảng cáo.
- `A3`: tập trung khách hàng trung thành.

Chiến lược của B:

- `B1`: giảm giá.
- `B2`: tăng quảng cáo.
- `B3`: tung sản phẩm gói combo.

Payoff `a_ij` là mức tăng thị phần tương đối của A so với B.

Nếu nghiệm hỗn hợp cho A là `[0.2, 0.5, 0.3]`, có thể diễn giải: A không nên chỉ giảm giá, mà nên phân bổ trọng tâm nhiều hơn vào quảng cáo, đồng thời vẫn giữ một phần chiến lược khách hàng trung thành để tránh bị B dự đoán.

Phân tích sâu: trong cạnh tranh thực tế, payoff không chỉ là lợi nhuận tức thời mà còn có chi phí thương hiệu, chi phí quảng cáo và phản ứng khách hàng. Mô hình zero-sum hợp lý nếu chỉ xét thị phần tương đối trong ngắn hạn.

## 26. Mẫu tình huống 2: an ninh mạng

Bối cảnh: Đội phòng thủ A bảo vệ hệ thống, hacker B chọn hướng tấn công.

Chiến lược của A:

- `A1`: tăng giám sát mạng.
- `A2`: vá lỗ hổng ứng dụng.
- `A3`: huấn luyện chống phishing.

Chiến lược của B:

- `B1`: tấn công DDoS.
- `B2`: khai thác lỗ hổng web.
- `B3`: phishing nhân viên.

Payoff `a_ij` là mức thiệt hại tránh được hoặc điểm an toàn tăng thêm cho A. Giá trị âm nghĩa là A bị thiệt hại lớn trong kịch bản đó.

Ý nghĩa nghiệm hỗn hợp: đội phòng thủ nên phân bổ nguồn lực theo xác suất tối ưu thay vì dồn toàn bộ vào một lớp phòng thủ. Hacker nếu biết A phòng thủ cố định sẽ đổi hướng tấn công, nên chiến lược hỗn hợp phản ánh tư duy phân tán rủi ro.

## 27. Mẫu tình huống 3: kiểm tra chất lượng

Bối cảnh: Cơ quan kiểm định A muốn phát hiện lỗi, nhà sản xuất B muốn giảm chi phí và có thể che giấu lỗi.

Chiến lược của A:

- `A1`: kiểm tra mẫu ngẫu nhiên.
- `A2`: kiểm tra toàn bộ lô rủi ro cao.
- `A3`: kiểm tra theo lịch bất ngờ.

Chiến lược của B:

- `B1`: tuân thủ đầy đủ.
- `B2`: giảm chất lượng ở công đoạn nguyên liệu.
- `B3`: giảm chất lượng ở công đoạn hoàn thiện.

Payoff `a_ij` là hiệu quả phát hiện và ngăn thiệt hại cho xã hội. Nghiệm tối ưu cho A có thể cho thấy kiểm tra bất ngờ cần được dùng với xác suất đáng kể để làm B khó dự đoán.

Phân tích xã hội: mô hình giúp giải thích vì sao cơ quan kiểm định không nên công khai lịch kiểm tra cố định. Tính ngẫu nhiên có giá trị chiến lược.

## 28. Những hạn chế lý thuyết cần biết

Mô hình game matrix zero-sum mạnh nhưng có giới hạn:

- Payoff thường khó định lượng chính xác.
- Giả định hai bên lý trí hoàn toàn.
- Giả định hai bên biết ma trận payoff.
- Giả định trò chơi diễn ra một lượt hoặc có thể quy về một lượt.
- Không phản ánh hợp tác, đàm phán hoặc lợi ích cùng thắng.
- Không phản ánh học hỏi động theo thời gian nếu không mở rộng mô hình.

Nêu được hạn chế giúp báo cáo chín chắn hơn.

## 29. Những hạn chế cụ thể của code hiện tại

Code hiện tại có nhiều điểm tốt, nhưng cần hiểu các hạn chế:

- Chưa dừng sớm khi có saddle point, nên vẫn chạy LP dù có thể không cần.
- So sánh `maximin == minimax` có thể không bền với số thực; nên dùng `abs(maximin - minimax) < tol`.
- Chưa kiểm tra `NaN`, `Inf`.
- Chưa lấy `exitflag` của `linprog`.
- Chưa hiển thị vị trí saddle point.
- Chưa xử lý chiến lược bị trội.
- Chưa định dạng số đầu ra theo số chữ số thập phân thống nhất.
- Chưa tách solver thành file riêng để kiểm thử độc lập.

Nếu giáo viên hỏi cải tiến, đây là các ý rất tốt để trả lời.

## 30. Tài liệu tham khảo nên dùng

Các nguồn phù hợp với yêu cầu học thuật:

1. Osborne, M. J. (2004). *An Introduction to Game Theory*. Oxford University Press.
2. Taha, H. A. (2017). *Operations Research: An Introduction* (10th ed.). Pearson.
3. Von Neumann, J., & Morgenstern, O. (1944). *Theory of Games and Economic Behavior*. Princeton University Press.
4. Ferguson, T. S. *Game Theory*. UCLA lecture notes.
5. Bertsimas, D., & Tsitsiklis, J. N. (1997). *Introduction to Linear Optimization*. Athena Scientific.

Khi đưa vào báo cáo, cần trích dẫn đúng định dạng. Không nên chỉ liệt kê link web thiếu tác giả hoặc thiếu năm.

## 31. Tóm tắt để học nhanh trước vấn đáp

Nếu chỉ còn ít thời gian, cần nắm chắc các ý sau:

- Ma trận payoff `A` biểu diễn lợi ích của A; B nhận đối nghịch vì zero-sum.
- A chọn hàng, B chọn cột.
- `maximin = max_i min_j a_ij` là mức A đảm bảo được.
- `minimax = min_j max_i a_ij` là mức B ép A không vượt quá.
- Nếu `maximin = minimax`, có saddle point và nghiệm thuần.
- Nếu không có saddle point, dùng chiến lược hỗn hợp.
- Chiến lược hỗn hợp là vector xác suất không âm, tổng bằng 1.
- Payoff kỳ vọng là `x^T A y`.
- Định lý minimax bảo đảm tồn tại nghiệm hỗn hợp tối ưu và giá trị trò chơi.
- Bài toán tìm mixed strategies có thể đưa về quy hoạch tuyến tính.
- Code MATLAB dùng `linprog`, dịch ma trận để payoff dương, chuẩn hóa nghiệm và tính lại giá trị trên ma trận gốc.
- Khi giải thích ứng dụng, phải nói rõ bối cảnh, giả định, ý nghĩa từng payoff và ý nghĩa chiến lược tối ưu.

