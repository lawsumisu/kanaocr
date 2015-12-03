function plotBitmap(v,x,y)
%PLOTCHAR Plot an n element vector as a x by y grid.
%  
%  PLOTCHAR(V)
%    V - an element vector of length x*y.
%    V's elements are plotted as a x by y grid.

% DEFINE BOX
x1 = [-0.5 -0.5 +0.5 +0.5 -0.5];
y1 = [-0.5 +0.5 +0.5 -0.5 -0.5];

% DEFINE BOX WITH X
x2 = [x1 +0.5 +0.5 -0.5];
y2 = [y1 +0.5 -0.5 +0.5];

xoff = 1.5;
yoff = 0.5;
newplot;
plot(x1*(x+1)+x/2,y1*(y+1)+y/2,'m');
axis([-xoff x+xoff -yoff y+yoff]);
axis('equal')
axis off
hold on

A = reshape(v, y,x);
for j = 1:y
    for i = 1:x
        plot(x2*A(j,i)+ i, y2*A(j,i) + y-j);
    end
end

hold off