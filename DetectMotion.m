function[Motion, t]=DetectMotion(BaselineFrame,currFrame)

% written by Tanvi Deora 2017/09/22 to detect moth ...
% moving in a background of a flower. 

% Input = 2 frames, comapre current Frame to one BaselineFrame
% Output = 1 (if you see motion) or 0 (if you don't see motion)


tic

BaselineFrame_prosecd=histeq(BaselineFrame);
thresh =20000 ;
se = strel('disk',4);

video_prosecd=histeq(currFrame);
diff= imsubtract(video_prosecd, BaselineFrame_prosecd);
diff_new=imerode(diff,se); 
out = sum(diff_new(:));
if out > thresh
   Motion = 1;
else
      Motion = 0;
end

t=toc;



