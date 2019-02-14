
function wallout = WallGeneration(WallStarty, Wallendy,WallStartx ,Wallendx,walltype)

% Create Wall Object
Numberpointsy = abs(WallStarty)+abs(Wallendy);
Numberpointsx = abs(WallStartx)+abs(Wallendx);

if walltype == 'h'
      Wall2(1,:) = [WallStarty, WallStartx];
  for x=2:Numberpointsy/0.01
      Wall2(x,:) = [WallStarty+(x*0.01), WallStartx];
  end  
end

if walltype == 'v'
    Wall2(1,:) = [WallStarty, WallStartx];
  for x=1:Numberpointsx/0.01
      Wall2(x,:) = [WallStarty, WallStartx+(x*0.01)];
  end  
end

wallout = Wall2;
end
