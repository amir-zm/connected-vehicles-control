function [TAbleDRAC, TAbleTTC, TAbleInpuT, TAbleACC, TAbleJRK] = computeTAbleResults(TAble, MeaN, StD)
    % Constructs cell arrays for summary tables (mean ± std) per trajectory and IFT.
    TAbleDRAC = cell(5, 10);
    TAbleTTC = cell(5, 10);
    TAbleInpuT = cell(5, 10);
    TAbleACC = cell(5, 10);
    TAbleJRK = cell(5, 10);
    for i = 1:follwers_num+1
        for j = 1:ift_num
            TAbleDRAC{i,j} = [num2str(TAble(:,MeaN,i,1,j,1)*100,'%.3f') '±' num2str(TAble(:,StD,i,1,j,1)*100,'%.3f')];
            TAbleTTC{i,j} = [num2str(TAble(:,MeaN,i,1,j,2),'%.3f') '±' num2str(TAble(:,StD,i,1,j,2),'%.3f')];
            TAbleInpuT{i,j} = [num2str(TAble(:,MeaN,i,1,j,3)/100000000,'%.3f') '±' num2str(TAble(:,StD,i,1,j,3)/100000000,'%.3f')];
            TAbleACC{i,j} = [num2str(TAble(:,MeaN,i,1,j,4)/10,'%.3f') '±' num2str(TAble(:,StD,i,1,j,4)/10,'%.3f')];
            TAbleJRK{i,j} = [num2str(TAble(:,MeaN,i,1,j,5)/10,'%.3f') '±' num2str(TAble(:,StD,i,1,j,5)/10,'%.3f')];
        end
    end
end

