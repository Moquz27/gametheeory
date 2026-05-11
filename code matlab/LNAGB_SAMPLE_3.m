function LNAGB_SAMPLE_3()

clc;
clear;

%% GraphicalUserInterface

fig = uifigure('Name','NxM Matrix Game Solver','Position',[100 100 1200 720]);

%title
uilabel(fig,'Text','NxM Zero-Sum Matrix Game Solver','Position',[380 670 450 30],'FontSize',22,'FontWeight','bold');

%% MatrixSizeInput

%input labels
uilabel(fig,'Text','Rows (Player A)','Position',[80 620 150 25],'FontSize',14);

rowField = uieditfield(fig,'numeric','Position',[220 620 80 25],'Value',3);

uilabel(fig,'Text','Columns (Player B)','Position',[350 620 170 25],'FontSize',14);

colField = uieditfield(fig,'numeric','Position',[540 620 80 25],'Value',3);

%% Buttons

% create matrix button
createBtn = uibutton(fig,'push','Text','Create Matrix','Position',[680 620 140 35],'FontSize',14,'ButtonPushedFcn',@(btn,event) createMatrix());

% solve button
solveBtn = uibutton(fig,'push','Text','Solve Game','Position',[850 620 140 35],'FontSize',14,'ButtonPushedFcn',@(btn,event) solveGame());

% chart button
chartBtn = uibutton(fig,'push','Text','Show Charts','Position',[1020 620 140 35],'FontSize',14,'ButtonPushedFcn',@(btn,event) showCharts());

%% MatrixInputTable

%input labels
uilabel(fig,'Text','Enter Payoff Matrix A','Position',[470 560 250 30],'FontSize',18);

% default table
matrixTable = uitable(fig,'Data',zeros(3,3),'Position',[250 300 700 240],'ColumnEditable',true);

%% ResultDisplay

%resultdisplay
resultText = uitextarea(fig,'Position',[120 30 950 240],'FontSize',14);

%% StoreResult

%storeresult
currentResult = [];

%% CreateMatrixCallback

    function createMatrix()

        % row value
        rows = round(rowField.Value);

        % column value
        cols = round(colField.Value);

        % validation
        if rows < 2 || cols < 2

            uialert(fig,'Matrix must be at least 2x2.','Invalid Size');

            return;

        end

        % create matrix
        matrixTable.Data = zeros(rows,cols);

    end

%% SolveCallback

    function solveGame()

        % payoff matrix
        A = matrixTable.Data;

        try

            % solve
            currentResult = mainGameSolver(A);

            %% ProperMatrixDisplay

            % matrix text
            matrixString = "";

            % loop rows
            for i = 1:size(A,1)

                matrixString = matrixString + "[ ";

                for j = 1:size(A,2)

                    matrixString = matrixString + num2str(A(i,j)) + " ";

                end

                matrixString = matrixString + "]" + newline;

            end

            % output
            output = "";

            output = output + "========== GAME THEORY RESULTS ==========" + newline + newline;

            output = output + "PAYOFF MATRIX:" + newline;

            output = output + matrixString + newline;

            output = output + "MAXIMIN VALUE = " + num2str(currentResult.maximin) + newline;

            output = output + "MINIMAX VALUE = " + num2str(currentResult.minimax) + newline + newline;

            % saddlepoint result
            if currentResult.hasSaddle

                output = output + "SADDLE POINT EXISTS" + newline;

            else

                output = output + "NO SADDLE POINT" + newline;

            end

            output = output + newline;

            % A strat
            output = output + "PLAYER A MIXED STRATEGY:" + newline;

            output = output + mat2str(currentResult.strategyA,4) + newline + newline;

            % B strat
            output = output + "PLAYER B MIXED STRATEGY:" + newline;

            output = output + mat2str(currentResult.strategyB,4) + newline + newline;

            % game value
            output = output + "VALUE OF THE GAME = " + num2str(currentResult.gameValue) + newline + newline;

            % payoff
            output = output + "EXPECTED PAYOFF x^T A y = " + num2str(currentResult.expectedValue);

            % displayresult
            resultText.Value = output;

        catch ME

            % foolproof
            resultText.Value = ME.message;

        end

    end

%% ChartCallBack

    function showCharts()

        % check for solutionz
        if isempty(currentResult)

            uialert(fig,'Solve the game first.','No Data');

            return;

        end

        % display
        plotStrategies(currentResult);

    end

end

%% SOLVER

function result = mainGameSolver(A)

%% ExtractMatrixSize

[m,n] = size(A);

%% SADDLEPOINT CALC

% nowmin
rowMin = min(A, [], 2);

% maximin
maximin = max(rowMin);

% maximumcolumns
colMax = max(A, [], 1);

% minimax
minimax = min(colMax);

% storeval
result.maximin = maximin;

result.minimax = minimax;

%% SaddlePointChecker

if maximin == minimax

    result.hasSaddle = true;

    result.gameValue = maximin;

else

    result.hasSaddle = false;

end

%% LinearProgrammingFormulation

% shift matrix
shiftValue = abs(min(A(:))) + 1;

Ashift = A + shiftValue;

%% SolveForPlayerA

% objective function
fA = ones(m,1);

% constraints
AA = -Ashift';

bA = -ones(n,1);

% lower bound
lbA = zeros(m,1);

% linear programming
x = linprog(fA,AA,bA,[],[],lbA);

% validation
if isempty(x)

    error('Unable to solve Player A strategy.');

end

% normalize
valueA = 1 / sum(x);

strategyA = x * valueA;

%% SolveForPlayerB

% objective function
fB = ones(n,1);

% constraints
AB = -Ashift;

bB = -ones(m,1);

% lower bound
lbB = zeros(n,1);

% linear programming
y = linprog(fB,AB,bB,[],[],lbB);

% validation
if isempty(y)

    error('Unable to solve Player B strategy.');

end

% normalize
valueB = 1 / sum(y);

strategyB = y * valueB;

%% GameValue

% average value
v = ((valueA + valueB)/2) - shiftValue;

%% ExpectedPayoff

expectedValue = strategyA' * A * strategyB;

%% StoreResults

result.strategyA = strategyA;

result.strategyB = strategyB;

result.gameValue = v;

result.expectedValue = expectedValue;

result.matrix = A;

end

%% C H A R T

function plotStrategies(result)

figure('Name','Game Theory Charts','NumberTitle','off','Position',[100 100 1400 450]);

%% PlayerAStrat

subplot(1,3,1);

bar(result.strategyA);

title('Player A Strategy');

xlabel('Strategies');

ylabel('Probability');

ylim([0 1]);

grid on;

%% PlayerBStrat

subplot(1,3,2);

bar(result.strategyB);

title('Player B Strategy');

xlabel('Strategies');

ylabel('Probability');

ylim([0 1]);

grid on;

%% PayoffHeatmap

subplot(1,3,3);

imagesc(result.matrix);

colorbar;

title('Payoff Matrix Heatmap');

xlabel('Player B');

ylabel('Player A');

[m,n] = size(result.matrix);

set(gca,'XTick',1:n,'YTick',1:m);

textStrings = strtrim(cellstr(num2str(result.matrix(:))));

[x,y] = meshgrid(1:n,1:m);

text(x(:),y(:),textStrings(:),'HorizontalAlignment','center','FontSize',12,'Color','white');

end