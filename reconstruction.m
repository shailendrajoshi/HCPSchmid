function [ ] = reconstruction( )
% callback of the calculate button.

% reconstruct axis.
defineAxes('redraw');

% change of atom locations (top and mid layers only).
complexHex = getappdata(gcf,'complexHex');
atoms = getappdata(gcf,'atoms');
base = atoms(:,1:7);
top = [real(complexHex);imag(complexHex);caRatio*ones(1,7)];
complexMid = (1/ sqrt(3))*exp(pi*1i*(1/6:2/3:3/2));
mid = [real(complexMid);imag(complexMid);ones(1,3)*.5*caRatio];
atoms = [base mid top];
setappdata(gcf,'atoms',atoms);

drawSkeleton();
defineSystem();

showAtomsBox('value edited');
showMidLayer('value edited');
set(gca,'projection',get(get(findobj('tag','projection'),'selectedobject'),'string'));

status('Calculation complete.'); rotate3d;
end

