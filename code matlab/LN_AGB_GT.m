function LN_AGB_GT()

clc; clear;

%% GraphicalUserInterface
fig=uifigure('Name','NxM Matrix Game Solver','Position',[100 100 1200 720]);
uilabel(fig,'Text','NxM Zero-Sum Matrix Game Solver','Position',[380 670 450 30],'FontSize',22,'FontWeight','bold');

%% MatrixSizeInput
uilabel(fig,'Text','Rows (Player A)','Position',[80 620 150 25],'FontSize',14);
rowField=uieditfield(fig,'numeric','Position',[220 620 80 25],'Value',3);

uilabel(fig,'Text','Columns (Player B)','Position',[350 620 170 25],'FontSize',14);
colField=uieditfield(fig,'numeric','Position',[540 620 80 25],'Value',3);

%% Buttons
uibutton(fig,'push','Text','Create Matrix','Position',[680 620 140 35],'FontSize',14,'ButtonPushedFcn',@(btn,event)createMatrix());

uibutton(fig,'push','Text','Solve Game','Position',[850 620 140 35],'FontSize',14,'ButtonPushedFcn',@(btn,event)solveGame());

uibutton(fig,'push','Text','Show Charts','Position',[1020 620 140 35],'FontSize',14,'ButtonPushedFcn',@(btn,event)showCharts());

%% MatrixInputTable
uilabel(fig,'Text','Enter Payoff Matrix A','Position',[470 560 250 30],'FontSize',18);

matrixTable=uitable(fig,'Data',zeros(3,3),'Position',[250 300 700 240]);
matrixTable.ColumnEditable=true(1,3);

%% ResultDisplay
resultText=uitextarea(fig,'Position',[120 30 950 240],'FontSize',14);

%% StoreResult
currentResult=[];

%% CreateMatrixCallback
function createMatrix()

r=round(rowField.Value);
c=round(colField.Value);

if ~isfinite(r)||~isfinite(c)||r<2||c<2
uialert(fig,'Matrix must be at least 2x2.','Invalid Size');
return;
end

matrixTable.Data=zeros(r,c);
matrixTable.ColumnEditable=true(1,c);

end

%% SolveCallback
function solveGame()

A=matrixTable.Data;

try

currentResult=mainGameSolver(A);

matrixRows=strings(size(A,1),1);

for i=1:size(A,1)
matrixRows(i)="[ "+join(string(A(i,:))," ")+" ]";
end

matrixString=join(matrixRows,newline);

output=["========== GAME THEORY RESULTS ==========","","PAYOFF MATRIX:",matrixString,"","MAXIMIN VALUE = "+num2str(currentResult.maximin),"MINIMAX VALUE = "+num2str(currentResult.minimax),""];

if currentResult.hasSaddle

saddleList=strings(size(currentResult.saddlePositions,1),1);

for k=1:size(currentResult.saddlePositions,1)
saddleList(k)="(A"+num2str(currentResult.saddlePositions(k,1))+", B"+num2str(currentResult.saddlePositions(k,2))+")";
end

saddleText=string(strjoin(cellstr(saddleList),', '));

output=[output,"SADDLE POINT EXISTS","SADDLE POINT POSITION(S) = "+saddleText];

else

output=[output,"NO SADDLE POINT"];

end

output=[output,"","PLAYER A MIXED STRATEGY:",mat2str(currentResult.strategyA,4),"","PLAYER B MIXED STRATEGY:",mat2str(currentResult.strategyB,4),"","VALUE OF THE GAME = "+num2str(currentResult.gameValue),"","EXPECTED PAYOFF xTransposeAy = "+num2str(currentResult.expectedValue)];

resultText.Value=output;

catch ME

resultText.Value=ME.message;

end

end

%% ChartCallBack
function showCharts()

if isempty(currentResult)||~isfield(currentResult,'matrix')
uialert(fig,'Solve the game first.','No Data');
return;
end

plotStrategies(currentResult);

end

end

%% SOLVER
function result=mainGameSolver(A)

if ~isnumeric(A)||~ismatrix(A)||isempty(A)
error('Payoff matrix must be a numeric matrix.');
end

if any(~isfinite(A(:)))
error('Payoff matrix must contain only finite values.');
end

%% ExtractMatrixSize
[m,n]=size(A);

if m<2||n<2
error('Matrix must be at least 2x2.');
end

%% SADDLEPOINT CALC
rowMin=min(A,[],2);
maximin=max(rowMin);

colMax=max(A,[],1);
minimax=min(colMax);

result.maximin=maximin;
result.minimax=minimax;

%% SaddlePointChecker
tol=1e-8*max(1,max(abs(A(:))));

if abs(maximin-minimax)<=tol

result.hasSaddle=true;

saddleRows=find(abs(rowMin-maximin)<=tol);
saddleCols=find(abs(colMax-minimax)<=tol);

saddleMask=false(m,n);
saddleMask(saddleRows,saddleCols)=true;

[saddleR,saddleC]=find(saddleMask&abs(A-maximin)<=tol);

if isempty(saddleR)
error('Unable to identify saddle point.');
end

saddlePositions=[saddleR saddleC];

strategyA=zeros(m,1);
strategyB=zeros(n,1);

strategyA(saddlePositions(1,1))=1;
strategyB(saddlePositions(1,2))=1;

result.saddleRow=saddlePositions(1,1);
result.saddleCol=saddlePositions(1,2);
result.saddlePositions=saddlePositions;

result.strategyA=strategyA;
result.strategyB=strategyB;

result.gameValue=maximin;

strategyATranspose=transpose(strategyA);

result.expectedValue=strategyATranspose*A*strategyB;

result.matrix=A;

return;

else

result.hasSaddle=false;

result.saddleRow=[];
result.saddleCol=[];
result.saddlePositions=[];

%% Algorithm Branching
if m==2&&n==2

%% 1. Algebraic formula for 2x2 games
a=A(1,1);
b=A(1,2);
c=A(2,1);
d=A(2,2);

den=a-b-c+d;

denTol=1e-8*max(1,abs(a)+abs(b)+abs(c)+abs(d));

if abs(den)<=denTol
error('Degenerate 2x2 game.');
end

p=(d-c)/den;
q=(d-b)/den;

probTol=1e-8;

if p<-probTol||p>1+probTol||q<-probTol||q>1+probTol
error('Invalid mixed strategy probabilities.');
end

p=max(0,min(1,p));
q=max(0,min(1,q));

strategyA=[p;1-p];
strategyB=[q;1-q];

v=(a*d-b*c)/den;

else

%% 2. Linear programming for general m x n games
shift=abs(min(A(:)))+1;

A1=A+shift;

opt=optimoptions('linprog','Display','none');

fA=ones(m,1);

[x,~,exitflagA]=linprog(fA,-transpose(A1),-ones(n,1),[],[],zeros(m,1),[],opt);

if isempty(x)||exitflagA<=0
error('Unable to solve Player A strategy.');
end

valueA=1/sum(x);

strategyA=x*valueA;

fB=-ones(n,1);

[y,~,exitflagB]=linprog(fB,A1,ones(m,1),[],[],zeros(n,1),[],opt);

if isempty(y)||exitflagB<=0
error('Unable to solve Player B strategy.');
end

valueB=1/sum(y);

strategyB=y*valueB;

%% Game value
v=((valueA+valueB)/2)-shift;

end

%% Expected Payoff and Store Results
strategyATranspose=transpose(strategyA);

expectedValue=strategyATranspose*A*strategyB;

result.strategyA=strategyA;
result.strategyB=strategyB;

result.gameValue=v;
result.expectedValue=expectedValue;

result.matrix=A;

end

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

[m,n]=size(result.matrix);

set(gca,'XTick',1:n,'YTick',1:m);

textStrings=string(result.matrix(:));

[x,y]=meshgrid(1:n,1:m);

text(x(:),y(:),textStrings(:),'HorizontalAlignment','center','FontSize',12,'Color','white');

end
