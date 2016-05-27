function [ UR2,UV2,UB2 ] = HDR_color( ImageOriginale )

D=size(ImageOriginale);
M=D(1);
N=D(2);

UR=cat(3,ImageOriginale(:,:,1),ImageOriginale(:,:,1),ImageOriginale(:,:,1));
UV=cat(3,ImageOriginale(:,:,2),ImageOriginale(:,:,2),ImageOriginale(:,:,2));
UB=cat(3,ImageOriginale(:,:,3),ImageOriginale(:,:,3),ImageOriginale(:,:,3));
UR2=double(UR(:,1:N));
UV2=double(UV(:,N+1:2*N));
UB2=double(UB(:,2*N+1:3*N));

end

