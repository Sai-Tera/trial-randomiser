close all
clear all %#ok
clc

% to 15, poss not do35 depending on the time

numOfGroups = 1;
control = 15; % Control latency
random = true;

rng('shuffle') % Random seed

for group = 1:numOfGroups
    clear myStruct
    myStruct.trial = [];
    myStruct.tempo = [];
    myStruct.p1 = [];
    myStruct.p2 = [];
    myStruct.p3 = [];
    myStruct.l1_2 = [];
    myStruct.l1_3 = [];
    myStruct.l2_1 = [];
    myStruct.l2_3 = [];
    myStruct.l3_1 = [];
    myStruct.l3_2 = [];

    % 2 Set
    for j = 1:2

        % Control
        incr = 0;
        if j == 1 % Set A
            index = 1:5;
            tempo = 'fast';
        else % Set B
            cLen = length(myStruct)+1;
            index = cLen:cLen+4;
            tempo = 'slow';
        end
        for i = index
            myStruct(i).trial = i;
            myStruct(i).tempo = tempo;
            myStruct(i).p1 = control+incr;
            myStruct(i).p2 = control+incr;
            myStruct(i).p3 = control+incr;
            myStruct(i).l1_2 = control+incr;
            myStruct(i).l1_3 = control+incr;
            myStruct(i).l2_1 = control+incr;
            myStruct(i).l2_3 = control+incr;
            myStruct(i).l3_1 = control+incr;
            myStruct(i).l3_2 = control+incr;
            incr = incr+5;
        end

        % Condition 1-4
        con = 5;
        for i = 1:4
            cLen = length(myStruct)+1;
            for k = cLen:cLen+2
                myStruct(k).trial = k;
                myStruct(k).tempo = tempo;
                myStruct(k).l1_2 = control;
                myStruct(k).l1_3 = control;
                myStruct(k).l2_1 = control;
                myStruct(k).l2_3 = control;
                myStruct(k).l3_1 = control;
                myStruct(k).l3_2 = control;
                if k == cLen
                    myStruct(k).p1 = control+con;
                    myStruct(k).l1_2 = control+con;
                    myStruct(k).l1_3 = control+con;
                    myStruct(k).l2_1 = control+con;
                    myStruct(k).l3_1 = control+con;

                elseif k == cLen+1
                    myStruct(k).p2 = control+con;
                    myStruct(k).l2_1 = control+con;
                    myStruct(k).l2_3 = control+con;
                    myStruct(k).l1_2 = control+con;
                    myStruct(k).l3_2 = control+con;
                elseif k == cLen+2
                    myStruct(k).p3 = control+con;
                    myStruct(k).l3_1 = control+con;
                    myStruct(k).l3_2 = control+con;
                    myStruct(k).l1_3 = control+con;
                    myStruct(k).l2_3 = control+con;
                end
            end
            con = con+5;
        end

        % Condition 5 (Asymm)
        cLen = length(myStruct)+1;
        for k = cLen:cLen+2
            myStruct(k).trial = k;
            myStruct(k).tempo = tempo;
            if k == cLen
                myStruct(k).l1_2 = control+20;
                myStruct(k).l1_3 = control;
                myStruct(k).l2_1 = control+20;
                myStruct(k).l2_3 = control+10;
                myStruct(k).l3_1 = control;
                myStruct(k).l3_2 = control+10;
            elseif k == cLen+1
                myStruct(k).l1_2 = control;
                myStruct(k).l1_3 = control+10;
                myStruct(k).l2_1 = control;
                myStruct(k).l2_3 = control+20;
                myStruct(k).l3_1 = control+10;
                myStruct(k).l3_2 = control+20;
            elseif k == cLen+2
                myStruct(k).l1_2 = control+10;
                myStruct(k).l1_3 = control+20;
                myStruct(k).l2_1 = control+10;
                myStruct(k).l2_3 = control;
                myStruct(k).l3_1 = control+20;
                myStruct(k).l3_2 = control;
            end
        end
    end

    if random

    myStruct = myStruct(randperm(numel(myStruct))); % Randomise trials

    % Scan for 3 or more consecutive trials, if found, random again
    found = true;
    while found
        trials = [myStruct.trial];
        i = 1;
        found = false;

        while i <= length(trials)-2 % Checking group of 3
            run = trials(i);
            j = i;

            while j < length(trials) && abs(trials(j+1)-trials(j)) == 1
                run = [run trials(j+1)];
                j = j + 1;
            end

            if length(run) >= 3
                disp(['Found consecutive numbers: ' num2str(run) ' — rerandomising'])
                myStruct = myStruct(randperm(numel(myStruct)));
                found = true;
                break;
            end

            i = j + 1;
        end
    end

    disp('No 3 consecutive numbers found — done')

    % Sort the trials entry in order
    [~, index] = sort([myStruct.trial]);
    % myStruct = myStruct(index); % <----

    % Store seed
    seed = (rng);
    seed = seed.Seed;
    myStruct(1).seed = seed;

    end

    Table = struct2table(myStruct);
    writetable(Table,"Group_" + group + ".xlsx");
end
