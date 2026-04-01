close all
clear all %#ok
clc

numOfGroups = 20;
control = 10; % Control latency
myStruct.trial = [];
myStruct.tempo = [];
myStruct.p1 = [];
myStruct.p2 = [];
myStruct.p3 = [];

rng('shuffle') % Random seed

for group = 1:numOfGroups
  clear myStruct
  
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
      incr = incr+5;
    end
    
    % Condition 1-4
    con = 5;
    for i = 1:4
      cLen = length(myStruct)+1;
      for k = cLen:cLen+2
        myStruct(k).trial = k;
        myStruct(k).tempo = tempo;
        myStruct(k).p1 = control;
        myStruct(k).p2 = control;
        myStruct(k).p3 = control;
        if k == cLen
          myStruct(k).p1 = control+con;
        elseif k == cLen+1
          myStruct(k).p2 = control+con;
        elseif k == cLen+2
          myStruct(k).p3 = control+con;
        end
      end
      con = con+5;
    end
    
    % Condition 5 (Asymm)
    cLen = length(myStruct)+1;
    for k = cLen:cLen+2
      myStruct(k).trial = k;
      myStruct(k).tempo = tempo;
      myStruct(k).p1 = control;
      myStruct(k).p2 = control;
      myStruct(k).p3 = control;
      if k == cLen
        myStruct(k).p1 = control+20;
        myStruct(k).p2 = control+10;
      elseif k == cLen+1
        myStruct(k).p2 = control+20;
        myStruct(k).p3 = control+10;
      elseif k == cLen+2
        myStruct(k).p3 = control+20;
        myStruct(k).p1 = control+10;
      end
    end
  end
  
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
  
  Table = struct2table(myStruct);
  writetable(Table,"Group_" + group + ".xlsx");
end
