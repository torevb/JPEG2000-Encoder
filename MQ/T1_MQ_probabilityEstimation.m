function [ Qe, NMPS, NLPS, switchValue ] = T1_MQ_probabilityEstimation( indexCX )
%QE Summary of this function goes here
%   NMPS and NLPS are short for "Next index if MPS/LPS". 
    %
    
    switch indexCX
        case 0
            Qe = hex2dec('5601');	NMPS = 1;	NLPS = 1;	switchValue = 1;
        case 1
            Qe = hex2dec('3401');	NMPS = 2;	NLPS = 6;	switchValue = 0;
        case 2
            Qe = hex2dec('1801');	NMPS = 3;	NLPS = 9;	switchValue = 0;
        case 3
            Qe = hex2dec('0AC1');	NMPS = 4;	NLPS = 12;	switchValue = 0;
        case 4
            Qe = hex2dec('0521');	NMPS = 5;	NLPS = 29;	switchValue = 0;
        case 5
            Qe = hex2dec('0221');	NMPS = 38;	NLPS = 33;	switchValue = 0;
        case 6
            Qe = hex2dec('5601');	NMPS = 7;	NLPS = 6;	switchValue = 1;
        case 7
            Qe = hex2dec('5401');	NMPS = 8;	NLPS = 14;	switchValue = 0;
        case 8
            Qe = hex2dec('4801');	NMPS = 9;	NLPS = 14;	switchValue = 0;
        case 9
            Qe = hex2dec('3801');	NMPS = 10;	NLPS = 14;	switchValue = 0;
        case 10
            Qe = hex2dec('3001');	NMPS = 11;	NLPS = 17;	switchValue = 0;
        case 11
            Qe = hex2dec('2401');	NMPS = 12;	NLPS = 18;	switchValue = 0;
        case 12
            Qe = hex2dec('1C01');	NMPS = 13;	NLPS = 20;	switchValue = 0;
        case 13
            Qe = hex2dec('1601');	NMPS = 29;	NLPS = 21;	switchValue = 0;
        case 14
            Qe = hex2dec('5601');	NMPS = 15;	NLPS = 14;	switchValue = 1;
        case 15
            Qe = hex2dec('5401');	NMPS = 16;	NLPS = 14;	switchValue = 0;
        case 16
            Qe = hex2dec('5101');	NMPS = 17;	NLPS = 15;	switchValue = 0;
        case 17
            Qe = hex2dec('4801');	NMPS = 18;	NLPS = 16;	switchValue = 0;
        case 18
            Qe = hex2dec('3801');	NMPS = 19;	NLPS = 17;	switchValue = 0;
        case 19
            Qe = hex2dec('3401');	NMPS = 20;	NLPS = 18;	switchValue = 0;
        case 20
            Qe = hex2dec('3001');	NMPS = 21;	NLPS = 19;	switchValue = 0;
        case 21
            Qe = hex2dec('2801');	NMPS = 22;	NLPS = 19;	switchValue = 0;
        case 22
            Qe = hex2dec('2401');	NMPS = 23;	NLPS = 20;	switchValue = 0;
        case 23
            Qe = hex2dec('2201');	NMPS = 24;	NLPS = 21;	switchValue = 0;
        case 24
            Qe = hex2dec('1C01');	NMPS = 25;	NLPS = 22;	switchValue = 0;
        case 25
            Qe = hex2dec('1801');	NMPS = 26;	NLPS = 23;	switchValue = 0;
        case 26
            Qe = hex2dec('1601');	NMPS = 27;	NLPS = 24;	switchValue = 0;
        case 27
            Qe = hex2dec('1401');	NMPS = 28;	NLPS = 25;	switchValue = 0;
        case 28
            Qe = hex2dec('1201');	NMPS = 29;	NLPS = 26;	switchValue = 0;
        case 29
            Qe = hex2dec('1101');	NMPS = 30;	NLPS = 27;	switchValue = 0;
        case 30
            Qe = hex2dec('0AC1');	NMPS = 31;	NLPS = 28;	switchValue = 0;
        case 31
            Qe = hex2dec('09C1');	NMPS = 32;	NLPS = 29;	switchValue = 0;
        case 32
            Qe = hex2dec('08A1');	NMPS = 33;	NLPS = 30;	switchValue = 0;
        case 33
            Qe = hex2dec('0521');	NMPS = 34;	NLPS = 31;	switchValue = 0;
        case 34
            Qe = hex2dec('0441');	NMPS = 35;	NLPS = 32;	switchValue = 0;
        case 35
            Qe = hex2dec('02A1');	NMPS = 36;	NLPS = 33;	switchValue = 0;
        case 36
            Qe = hex2dec('0221');	NMPS = 37;	NLPS = 34;	switchValue = 0;
        case 37
            Qe = hex2dec('0141');	NMPS = 38;	NLPS = 35;	switchValue = 0;
        case 38
            Qe = hex2dec('0111');	NMPS = 39;	NLPS = 36;	switchValue = 0;
        case 39
            Qe = hex2dec('0085');	NMPS = 40;	NLPS = 37;	switchValue = 0;
        case 40
            Qe = hex2dec('0049');	NMPS = 41;	NLPS = 38;	switchValue = 0;
        case 41
            Qe = hex2dec('0025');	NMPS = 42;	NLPS = 39;	switchValue = 0;
        case 42
            Qe = hex2dec('0015');	NMPS = 43;	NLPS = 40;	switchValue = 0;
        case 43
            Qe = hex2dec('0009');	NMPS = 44;	NLPS = 41;	switchValue = 0;
        case 44
            Qe = hex2dec('0005');	NMPS = 45;	NLPS = 42;	switchValue = 0;
        case 45
            Qe = hex2dec('0001');	NMPS = 45;	NLPS = 43;	switchValue = 0;
        case 46
            Qe = hex2dec('5601');	NMPS = 46;	NLPS = 46;	switchValue = 0;
    end
end

