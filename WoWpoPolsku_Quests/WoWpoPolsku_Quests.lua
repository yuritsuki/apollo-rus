-- Addon: QuestTranslator (version: 4.06) 2020.04.30
-- Description: AddOn displays translated quest information in original or separete window.
-- Autor: Platine  (e-mail: platine.wow@gmail.com)
-- WWW: https://wowpopolsku.pl

-- Global Variables
local QTR_version = "4.06";
local QTR_name = UnitName("player");
local QTR_class= UnitClass("player");
local QTR_race = UnitRace("player");
local QTR_sex = UnitSex("player");     -- 1:neutral,  2:męski,  3:żeński
local QTR_event="";
local QTR_waitTable = {};
local QTR_waitFrame = nil;
local QTR_MessOrig = {
      details    = "Description", 
      objectives = "Objectives", 
      rewards    = "Rewards", 
      itemchoose1= "You will be able to choose one of these rewards:", 
      itemchoose2= "Choose one of these rewards:", 
      itemreceiv1= "You will also receive:", 
      itemreceiv2= "You receiving the reward:", 
      learnspell = "Learn Spell:", 
      reqmoney   = "Required Money:", 
      reqitems   = "Required items:", 
      experience = "Experience:", 
      currquests = "Current Quests", 
      avaiquests = "Available Quests", };
local Original_Font1 = "Fonts\\MORPHEUS.ttf";
local Original_Font2 = "Fonts\\FRIZQT__.ttf";
local Tut_ID = 0;
local Tut_race = string.gsub(strupper(QTR_race)," ","");
local Tut_class= string.gsub(strupper(QTR_class)," ","");
if (Tut_class == "DEATHKNIGHT") then
   Tut_race = "DEATHKNIGHT";
end
if not QTR then
   QTR = { };
end

local p_race = {
      ["Blood Elf"] = { M1="Krwawy Elf", D1="krwawego elfa", C1="krwawemu elfowi", B1="krwawego elfa", N1="krwawym elfem", K1="krwawym elfie", W1="Krwawy Elfie", M2="Krwawa Elfka", D2="krwawej elfki", C2="krwawej elfce", B2="krwawą elfkę", N2="krwawą elfką", K2="krwawej elfce", W2="Krwawa Elfko" }, 
      ["Dark Iron Dwarf"] = { M1="Krasnolud Ciemnego Żelaza", D1="krasnoluda Ciemnego Żelaza", C1="krasnoludowi Ciemnego Żelaza", B1="krasnoluda Ciemnego Żelaza", N1="krasnoludem Ciemnego Żelaza", K1="krasnoludzie Ciemnego Żelaza", W1="Krasnoludzie Ciemnego Żelaza", M2="Krasnoludka Ciemnego Żelaza", D2="krasnoludki Ciemnego Żelaza", C2="krasnoludce Ciemnego Żelaza", B2="krasnoludkę Ciemnego Żelaza", N2="krasnoludką Ciemnego Żelaza", K2="krasnoludce Ciemnego Żelaza", W2="Krasnoludko Ciemnego Żelaza" },
      ["Draenei"] = { M1="Draenei", D1="draeneia", C1="draeneiowi", B1="draeneia", N1="draeneiem", K1="draeneiu", W1="Draeneiu", M2="Draeneika", D2="draeneiki", C2="draeneice", B2="draeneikę", N2="draeneiką", K2="draeneice", W2="Draeneiko" },
      ["Dwarf"] = { M1="Krasnolud", D1="krasnoluda", C1="krasnoludowi", B1="krasnoluda", N1="krasnoludem", K1="krasnoludzie", W1="Krasnoludzie", M2="Krasnoludka", D2="krasnoludki", C2="krasnoludce", B2="krasnoludkę", N2="krasnoludką", K2="krasnoludce", W2="Krasnoludko" },
      ["Gnome"] = { M1="Gnom", D1="gnoma", C1="gnomowi", B1="gnoma", N1="gnomem", K1="gnomie", W1="Gnomie", M2="Gnomka", D2="gnomki", C2="gnomce", B2="gnomkę", N2="gnomką", K2="gnomce", W2="Gnomko" },
      ["Goblin"] = { M1="Goblin", D1="goblina", C1="goblinowi", B1="goblina", N1="goblinem", K1="goblinie", W1="Goblinie", M2="Goblinka", D2="goblinki", C2="goblince", B2="goblinkę", N2="goblinką", K2="goblince", W2="Goblinko" },
      ["Highmountain Tauren"] = { M1="Tauren z Wysokiej Góry", D1="taurena z Wysokiej Góry", C1="taurenowi z Wysokiej Góry", B1="taurena z Wysokiej Góry", N1="taurenen z Wysokiej Góry", K1="taurenie z Wysokiej Góry", W1="Taurenie z Wysokiej Góry", M2="Taurenka z Wysokiej Góry", D2="taurenki z Wysokiej Góry", C2="taurence z Wysokiej Góry", B2="taurenkę z Wysokiej Góry", N2="taurenką z Wysokiej Góry", K2="taurence z Wysokiej Góry", W2="Taurenko z Wysokiej Góry" },
      ["Human"] = { M1="Człowiek", D1="człowieka", C1="człowiekowi", B1="człowieka", N1="człowiekiem", K1="człowieku", W1="Człowieku", M2="Człowiek", D2="człowieka", C2="człowiekowi", B2="człowieka", N2="człowiekiem", K2="człowieku", W2="Człowieku" },
      ["Kul Tiran"] = { M1="Kul Tiran", D1="Kul Tirana", C1="Kul Tiranowi", B1="Kul Tirana", N1="Kul Tiranem", K1="Kul Tiranie", W1="Kul Tiranie", M2="Kul Tiranka", D2="Kul Tiranki", C2="Kul Tirance", B2="Kul Tirankę", N2="Kul Tiranką", K2="Kul Tirance", W2="Kul Tiranko" },
      ["Lightforged Draenei"] = { M1="Świetlisty Draenei", D1="świetlistego draeneia", C1="świetlistemu draeneiowi", B1="świetlistego draeneia", N1="świetlistym draeneiem", K1="świetlistym draeneiu", W1="Świetlisty Draeneiu", M2="Świetlista Draeneika", D2="świetlistej draeneiki", C2="świetlistej draeneice", B2="świetlistą draeneikę", N2="świetlistą draeneiką", K2="świetlistej draeneice", W2="Świetlista Draeneiko" },
      ["Mag'har Orc"] = { M1="Ork z Mag'har", D1="orka z Mag'har", C1="orkowi z Mag'har", B1="orka z Mag'har", N1="orkiem z Mag'har", K1="orku z Mag'har", W1="Orku z Mag'har", M2="Orczyca z Mag'har", D2="orczycy z Mag'har", C2="orczycy z Mag'har", B2="orczycę z Mag'har", N2="orczycą z Mag'har", K2="orczyce z Mag'har", W2="Orczyco z Mag'har" },
      ["Nightborne"] = { M1="Dziecię Nocy", D1="dziecięcia nocy", C1="dziecięciu nocy", B1="dziecię nocy", N1="dziecięcem nocy", K1="dziecięciu nocy", W1="Dziecię Nocy", M2="Dziecię Nocy", D2="dziecięcia nocy", C2="dziecięciu nocy", B2="dziecię nocy", N2="dziecięcem nocy", K2="dziecięciu nocy", W2="Dziecię Nocy" },
      ["Night Elf"] = { M1="Nocny Elf", D1="nocnego elfa", C1="nocnemu elfowi", B1="nocnego elfa", N1="nocnym elfem", K1="nocnym elfie", W1="Nocny Elfie", M2="Nocna Elfka", D2="nocnej elfki", C2="nocnej elfce", B2="nocną elfkę", N2="nocną elfką", K2="nocnej elfce", W2="Nocna Elfko" },
      ["Orc"] = { M1="Ork", D1="orka", C1="orkowi", B1="orka", N1="orkiem", K1="orku", W1="Orku", M2="Orczyca", D2="orczycy", C2="orczycy", B2="orczycę", N2="orczycą", K2="orczycy", W2="Orczyco" },
      ["Pandaren"] = { M1="Pandaren", D1="pandarena", C1="pandarenowi", B1="pandarena", N1="pandarenem", K1="pandarenie", W1="Pandarenie", M2="Pandarenka", D2="pandarenki", C2="pandarence", B2="pandarenkę", N2="pandarenką", K2="pandarence", W2="Pandarenko" },
      ["Tauren"] = { M1="Tauren", D1="taurena", C1="taurenowi", B1="taurena", N1="taurenem", K1="taurenie", W1="Taurenie", M2="Taurenka", D2="taurenki", C2="taurence", B2="taurenkę", N2="taurenką", K2="taurence", W2="Taurenko" },
      ["Troll"] = { M1="Troll", D1="trolla", C1="trollowi", B1="trolla", N1="trollem", K1="trollu", W1="Trollu", M2="Trollica", D2="trollicy", C2="trollicy", B2="trollicę", N2="trollicą", K2="trollicy", W2="Trollico" },
      ["Undead"] = { M1="Nieumarły", D1="nieumarłego", C1="nieumarłemu", B1="nieumarłego", N1="nieumarłym", K1="nieumarłym", W1="Nieumarły", M2="Nieumarła", D2="nieumarłej", C2="nieumarłej", B2="nieumarłą", N2="nieumarłą", K2="nieumarłej", W2="Nieumarła" },
      ["Void Elf"] = { M1="Elf Pustki", D1="elfa Pustki", C1="elfowi Pustki", B1="elfa Pustki", N1="elfem Pustki", K1="elfie Pustki", W1="Elfie Pustki", M2="Elfka Pustki", D2="elfki Pustki", C2="elfce Pustki", B2="elfkę Pustki", N2="elfką Pustki", K2="elfce Pustki", W2="Elfko Pustki" },
      ["Worgen"] = { M1="Worgen", D1="worgena", C1="worgenowi", B1="worgena", N1="worgenem", K1="worgenie", W1="Worgenie", M2="Worgenka", D2="worgenki", C2="worgence", B2="worgenkę", N2="worgenką", K2="worgence", W2="Worgenko" },
      ["Zandalari Troll"] = { M1="Troll Zandalari", D1="trolla Zandalari", C1="trollowi Zandalari", B1="trolla Zandalari", N1="trollem Zandalari", K1="trollu Zandalari", W1="Trollu Zandalari", M2="Trollica Zandalari", D2="trollicy Zandalari", C2="trollicy Zandalari", B2="trollicę Zandalari", N2="trollicą Zandalari", K2="trollicy Zandalari", W2="Trollico Zandalari" }, }
local p_class = {
      ["Death Knight"] = { M1="Rycerz Śmierci", D1="rycerz śmierci", C1="rycerzowi śmierci", B1="rycerza śmierci", N1="rycerzem śmierci", K1="rycerzu śmierci", W1="Rycerzu Śmierci", M2="Rycerz Śmierci", D2="rycerz śmierci", C2="rycerzowi śmierci", B2="rycerza śmierci", N2="rycerzem śmierci", K2="rycerzu śmierci", W2="Rycerzu Śmierci" },
      ["Demon Hunter"] = { M1="Łowca demonów", D1="łowcy demonów", C1="łowcy demonów", B1="łowcę demonów", N1="łowcą demonów", K1="łowcy demonów", W1="Łowco demonów", M2="Łowczyni demonów", D2="łowczyni demonów", C2="łowczyni demonów", B2="łowczynię demonów", N2="łowczynią demonów", K2="łowczyni demonów", W2="Łowczyni demonów" },
      ["Druid"] = { M1="Druid", D1="druida", C1="druidowi", B1="druida", N1="druidem", K1="druidzie", W1="Druidzie", M2="Druidka", D2="druidki", C2="druidce", B2="druikę", N2="druidką", K2="druidce", W2="Druidko" },
      ["Hunter"] = { M1="Łowca", D1="łowcy", C1="łowcy", B1="łowcę", N1="łowcą", K1="łowcy", W1="Łowco", M2="Łowczyni", D2="łowczyni", C2="łowczyni", B2="łowczynię", N2="łowczynią", K2="łowczyni", W2="Łowczyni" },
      ["Mage"] = { M1="Czarodziej", D1="czarodzieja", C1="czarodziejowi", B1="czarodzieja", N1="czarodziejem", K1="czarodzieju", W1="Czarodzieju", M2="Czarodziejka", D2="czarodziejki", C2="czarodziejce", B2="czarodziejkę", N2="czarodziejką", K2="czarodziejce", W2="Czarodziejko" },
      ["Monk"] = { M1="Mnich", D1="mnicha", C1="mnichowi", B1="mnicha", N1="mnichem", K1="mnichu", W1="Mnichu", M2="Mniszka", D2="mniszki", C2="mniszce", B2="mniszkę", N2="mniszką", K2="mniszce", W2="Mniszko" },
      ["Paladin"] = { M1="Paladyn", D1="paladyna", C1="paladynowi", B1="paladyna", N1="paladynem", K1="paladynie", W1="Paladynie", M2="Paladynka", D2="paladynki", C2="paladynce", B2="paladynkę", N2="paladynką", K2="paladynce", W2="Paladynko" },
      ["Priest"] = { M1="Kapłan", D1="kapłana", C1="kapłanowi", B1="kapłana", N1="kapłanem", K1="kapłanie", W1="Kapłanie", M2="Kapłanka", D2="kapłanki", C2="kapłance", B2="kapłankę", N2="kapłanką", K2="kapłance", W2="Kapłanko" },
      ["Rogue"] = { M1="Łotrzyk", D1="łotrzyka", C1="łotrzykowi", B1="łotrzyka", N1="łotrzykiem", K1="łotrzyku", W1="Łotrzyku", M2="Łotrzyca", D2="łotrzycy", C2="łotrzycy", B2="łotrzycę", N2="łotrzycą", K2="łotrzycy", W2="Łotrzyco" },
      ["Shaman"] = { M1="Szaman", D1="szamana", C1="szamanowi", B1="szamana", N1="szamanem", K1="szamanie", W1="Szamanie", M2="Szamanka", D2="szamanki", C2="szamance", B2="szamankę", N2="szamanką", K2="szamance", W2="Szamanko" },
      ["Warlock"] = { M1="Czarnoksiężnik", D1="czarnoksiężnika", C1="czarnoksiężnikowi", B1="czarnoksiężnika", N1="czarnoksiężnikiem", K1="czarnoksiężniku", W1="Czarnoksiężniku", M2="Czarownica", D2="czarownicy", C2="czarownicy", B2="czarownicę", N2="czarownicą", K2="czarownicy", W2="Czarownico" },
      ["Warrior"] = { M1="Wojownik", D1="wojownika", C1="wojownikowi", B1="wojownika", N1="wojownikiem", K1="wojowniku", W1="Wojowniku", M2="Wojowniczka", D2="wojowniczki", C2="wojowniczce", B2="wojowniczkę", N2="wojowniczką", K2="wojowniczce", W2="Wojowniczko" }, }
if (p_race[QTR_race]) then      
   player_race = { M1=p_race[QTR_race].M1, D1=p_race[QTR_race].D1, C1=p_race[QTR_race].C1, B1=p_race[QTR_race].B1, N1=p_race[QTR_race].N1, K1=p_race[QTR_race].K1, W1=p_race[QTR_race].W1, M2=p_race[QTR_race].M2, D2=p_race[QTR_race].D2, C2=p_race[QTR_race].C2, B2=p_race[QTR_race].B2, N2=p_race[QTR_race].N2, K2=p_race[QTR_race].K2, W2=p_race[QTR_race].W2 };
else   
   player_race = { M1=QTR_race, D1=QTR_race, C1=QTR_race, B1=QTR_race, N1=QTR_race, K1=QTR_race, W1=QTR_race, M2=QTR_race, D2=QTR_race, C2=QTR_race, B2=QTR_race, N2=QTR_race, K2=QTR_race, W2=QTR_race };
   DEFAULT_CHAT_FRAME:AddMessage("|cff55ff00QTR - новая раса: "..QTR_race);
end
if (p_class[QTR_class]) then
   player_class = { M1=p_class[QTR_class].M1, D1=p_class[QTR_class].D1, C1=p_class[QTR_class].C1, B1=p_class[QTR_class].B1, N1=p_class[QTR_class].N1, K1=p_class[QTR_class].K1, W1=p_class[QTR_class].W1, M2=p_class[QTR_class].M2, D2=p_class[QTR_class].D2, C2=p_class[QTR_class].C2, B2=p_class[QTR_class].B2, N2=p_class[QTR_class].N2, K2=p_class[QTR_class].K2, W2=p_class[QTR_class].W2 };
else
   player_class = { M1=QTR_class, D1=QTR_class, C1=QTR_class, B1=QTR_class, N1=QTR_class, K1=QTR_class, W1=QTR_class, M2=QTR_class, D2=QTR_class, C2=QTR_class, B2=QTR_class, N2=QTR_class, K2=QTR_class, W2=QTR_class };
   DEFAULT_CHAT_FRAME:AddMessage("|cff55ff00QTR - новый: "..QTR_class);
end



function Spr_Gender(msg)
   local nr_1, nr_2, nr_3 = 0;
   local QTR_forma = "";
   local nr_poz = string.find(msg, "YOUR_GENDER");    -- gdy nie znalazł, jest: nil; liczy od 1
   while (nr_poz and nr_poz>0) do
      nr_1 = nr_poz + 1;   
      while (string.sub(msg, nr_1, nr_1) ~= "(") do   -- szukaj nawiasu otwierającego
         nr_1 = nr_1 + 1;
      end
      if (string.sub(msg, nr_1, nr_1) == "(") then
         nr_2 =  nr_1 + 1;
         while (string.sub(msg, nr_2, nr_2) ~= ";") do   -- szukaj średnika oddzielającego
            nr_2 = nr_2 + 1;
         end
         if (string.sub(msg, nr_2, nr_2) == ";") then
            nr_3 = nr_2 + 1;
            while (string.sub(msg, nr_3, nr_3) ~= ")") do   -- szykaj nawiasu zamykającego
               nr_3 = nr_3 + 1;
            end
            if (string.sub(msg, nr_3, nr_3) == ")") then
               if (QTR_sex==3) then        -- forma żeńska
                  QTR_forma = string.sub(msg,nr_2+1,nr_3-1);
               else                        -- forma męska
                  QTR_forma = string.sub(msg,nr_1+1,nr_2-1);
               end
               msg = string.sub(msg,1,nr_poz-1) .. QTR_forma .. string.sub(msg,nr_3+1);
            end   
         end
      end
      nr_poz = string.find(msg, "YOUR_GENDER");
   end
   return msg;
end


local function StringHash(text)           -- funkcja tworząca Hash (32-bitowa liczba) podanego tekstu
  local counter = 1;
  local pomoc = 0;
  local dlug = string.len(text);
  for i = 1, dlug, 3 do 
    counter = math.fmod(counter*8161, 4294967279);  -- 2^32 - 17: Prime!
    pomoc = (string.byte(text,i)*16776193);
    counter = counter + pomoc;
    pomoc = ((string.byte(text,i+1) or (dlug-i+256))*8372226);
    counter = counter + pomoc;
    pomoc = ((string.byte(text,i+2) or (dlug-i+256))*3932164);
    counter = counter + pomoc;
  end
  return math.fmod(counter, 4294967291) -- 2^32 - 5: Prime (and different from the prime in the loop)
end


function QTR_CheckVars()
  if (not QTR_PS) then
     QTR_PS = {};
  end
  if (not QTR_PC) then
     QTR_PC = {};
  end
  if (not QTR_SAVED) then
     QTR_SAVED = {};
  end
  if (not QTR_GOSSIP) then
     QTR_GOSSIP = {};
  end
  -- initialize check options
  if (not QTR_PS["active"]) then
     QTR_PS["active"] = "1";   
  end
  if (not QTR_PS["mode"] ) then
     QTR_PS["mode"] = "1";   
  end
  if (not QTR_PS["transtitle"] ) then
     QTR_PS["transtitle"] = "0";   
  end
  if (not QTR_PS["size"] ) then
     QTR_PS["size"] = "1";   
  end
  if (not QTR_PS["width"] ) then
     QTR_PS["width"] = "1";   
  end

  -- set check buttons 
  if (QTR_PS["size"] == "1") then
     QTR_SizeH = 1;
  else 
     QTR_SizeH = 2;     
     QTRFrame1:SetHeight(525);
     QTR_QuestDetail:SetHeight(430);
     QTR_ToggleButton2:SetText("^");
  end
  if (QTR_PS["width"] == "1") then
     QTR_SizeW = 1;
  else 
     QTR_SizeW = 2;     
     QTRFrame1:SetWidth(525);
     QTR_QuestDetail:SetWidth(495);
     QTR_QuestTitle:SetWidth(495);
     QTR_ToggleButton3:SetText("<");
  end
  if (not QTR_PS["gossip"] ) then
     QTR_PS["gossip"] = "1";   
  end
  if (not QTR_PS["tutorial"] ) then
     QTR_PS["tutorial"] = "1";   
  end
  if ( QTR_PS["isGetQuestID"] ) then
     isGetQuestID=QTR_PS["isGetQuestID"];
  end;
  QTR_GS = {};       -- tablica na teksty oryginalne
end


function QTR_SetCheckButtonState()
  QTRCheckButton0:SetChecked(QTR_PS["active"]=="1");
  QTRCheckButton1:SetChecked(QTR_PS["mode"]=="1");
  QTRCheckButton2:SetChecked(QTR_PS["mode"]=="2");
  QTRCheckButton3:SetChecked(QTR_PS["transtitle"]=="1");
  QTRCheckButton4:SetChecked(QTR_PS["size"]=="1");
  QTRCheckButton5:SetChecked(QTR_PS["size"]=="2");
  QTRCheckButton6:SetChecked(QTR_PS["width"]=="1");
  QTRCheckButton7:SetChecked(QTR_PS["width"]=="2");
  QTRCheckButtonGossip:SetChecked(QTR_PS["gossip"]=="1");
  QTRCheckButtonTutorial:SetChecked(QTR_PS["tutorial"]=="1");
end


function QTR_BlizzardOptions()
  -- Create main frame for information text
  local QTROptions = CreateFrame("FRAME", "QTROptions");
  QTROptions:SetScript("OnShow", function(self) QTR_SetCheckButtonState() end);
  QTROptions.name = "WoWpoPolsku-Quests";
  InterfaceOptions_AddCategory(QTROptions);

  local QTROptionsHeader = QTROptions:CreateFontString(nil, "ARTWORK");
  QTROptionsHeader:SetFontObject(GameFontNormalLarge);
  QTROptionsHeader:SetJustifyH("LEFT"); 
  QTROptionsHeader:SetJustifyV("TOP");
  QTROptionsHeader:ClearAllPoints();
  QTROptionsHeader:SetPoint("TOPLEFT", 16, -16);
  QTROptionsHeader:SetText("WoWpoPolsku-Quests, ver. "..QTR_version.." ("..QTR_base..") by Platine © 2010-2018");

  local QTRDateOfBase = QTROptions:CreateFontString(nil, "ARTWORK");
  QTRDateOfBase:SetFontObject(GameFontNormalLarge);
  QTRDateOfBase:SetJustifyH("LEFT"); 
  QTRDateOfBase:SetJustifyV("TOP");
  QTRDateOfBase:ClearAllPoints();
  QTRDateOfBase:SetPoint("TOPRIGHT", QTROptionsHeader, "TOPRIGHT", 0, -22);
  QTRDateOfBase:SetText("Data bazy tłumaczeń: "..QTR_date);
  QTRDateOfBase:SetFont(QTR_Font2, 16);

  local QTRCheckButton0 = CreateFrame("CheckButton", "QTRCheckButton0", QTROptions, "OptionsCheckButtonTemplate");
  QTRCheckButton0:SetPoint("TOPLEFT", QTROptionsHeader, "BOTTOMLEFT", 0, -50);
  QTRCheckButton0:SetScript("OnClick", function(self) if (QTR_PS["active"]=="1") then QTR_PS["active"]="0" else QTR_PS["active"]="1" end; end);
  QTRCheckButton0Text:SetFont(QTR_Font2, 13);
  QTRCheckButton0Text:SetText(QTR_Interface.active);

  local QTROptionsMode0 = QTROptions:CreateFontString(nil, "ARTWORK");
  QTROptionsMode0:SetFontObject(GameFontWhite);
  QTROptionsMode0:SetJustifyH("LEFT");
  QTROptionsMode0:SetJustifyV("TOP");
  QTROptionsMode0:ClearAllPoints();
  QTROptionsMode0:SetPoint("TOPLEFT", QTRCheckButton0, "BOTTOMLEFT", 20, -25);
  QTROptionsMode0:SetFont(QTR_Font2, 13);
  QTROptionsMode0:SetText(QTR_Interface.mode);

  local QTRCheckButton1 = CreateFrame("CheckButton", "QTRCheckButton1", QTROptions, "OptionsCheckButtonTemplate");
  QTRCheckButton1:SetPoint("TOPLEFT", QTROptionsMode0, "BOTTOMLEFT", 0, -5);
  QTRCheckButton1:SetScript("OnClick", function(self) if (QTR_PS["mode"]=="2") then QTR_PS["mode"]="1" else QTR_PS["mode"]="2" end; QTRCheckButton2:SetChecked(QTR_PS["mode"]=="2"); end);
  QTRCheckButton1Text:SetFont(QTR_Font2, 13);
  QTRCheckButton1Text:SetText(QTR_Interface.mode1);

  local QTROptionsMode1 = QTROptions:CreateFontString(nil, "ARTWORK");
  QTROptionsMode1:SetFontObject(GameFontWhite);
  QTROptionsMode1:SetJustifyH("LEFT");
  QTROptionsMode1:SetJustifyV("TOP");
  QTROptionsMode1:ClearAllPoints();
  QTROptionsMode1:SetPoint("TOPLEFT", QTRCheckButton1, "BOTTOMLEFT", 30, 0);
  QTROptionsMode1:SetFont(QTR_Font2, 13);
  QTROptionsMode1:SetText(QTR_Interface.options1);
  local QTRCheckButton3 = CreateFrame("CheckButton", "QTRCheckButton3", QTROptions, "OptionsCheckButtonTemplate");
  QTRCheckButton3:SetPoint("TOPLEFT", QTROptionsMode1, "BOTTOMLEFT", 0, -5);
  QTRCheckButton3:SetScript("OnClick", function(self) if (QTR_PS["transtitle"]=="0") then QTR_PS["transtitle"]="1" else QTR_PS["transtitle"]="0" end; end);
  QTRCheckButton3Text:SetFont(QTR_Font2, 13);
  QTRCheckButton3Text:SetText(QTR_Interface.transtitle);

  local QTRCheckButton2 = CreateFrame("CheckButton", "QTRCheckButton2", QTROptions, "OptionsCheckButtonTemplate");
  QTRCheckButton2:SetPoint("TOPLEFT", QTRCheckButton3, "BOTTOMLEFT", -30, -15);
  QTRCheckButton2:SetScript("OnClick", function(self) if (QTR_PS["mode"]=="1") then QTR_PS["mode"]="2" else QTR_PS["mode"]="1" end; QTRCheckButton1:SetChecked(QTR_PS["mode"]=="1"); end);
  QTRCheckButton2Text:SetFont(QTR_Font2, 13);
  QTRCheckButton2Text:SetText(QTR_Interface.mode2);

  local QTROptionsMode2 = QTROptions:CreateFontString(nil, "ARTWORK");
  QTROptionsMode2:SetFontObject(GameFontWhite);
  QTROptionsMode2:SetJustifyH("LEFT");
  QTROptionsMode2:SetJustifyV("TOP");
  QTROptionsMode2:ClearAllPoints();
  QTROptionsMode2:SetPoint("TOPLEFT", QTRCheckButton2, "BOTTOMLEFT", 30, 0);
  QTROptionsMode2:SetFont(QTR_Font2, 13);
  QTROptionsMode2:SetText(QTR_Interface.options2);
  local QTRCheckButton4 = CreateFrame("CheckButton", "QTRCheckButton4", QTROptions, "OptionsCheckButtonTemplate");
  QTRCheckButton4:SetPoint("TOPLEFT", QTROptionsMode2, "BOTTOMLEFT", 0, -5);
  QTRCheckButton4:SetScript("OnClick", function(self) QTR_ChangeFrameHeight(); QTRCheckButton5:SetChecked(QTR_PS["size"]=="2"); end);
  QTRCheckButton4Text:SetFont(QTR_Font2, 13);
  QTRCheckButton4Text:SetText(QTR_Interface.height1);
  local QTRCheckButton5 = CreateFrame("CheckButton", "QTRCheckButton5", QTROptions, "OptionsCheckButtonTemplate");
  QTRCheckButton5:SetPoint("TOPLEFT", QTRCheckButton4, "BOTTOMLEFT", 0, 5);
  QTRCheckButton5:SetScript("OnClick", function(self) QTR_ChangeFrameHeight(); QTRCheckButton4:SetChecked(QTR_PS["size"]=="1"); end);
  QTRCheckButton5Text:SetFont(QTR_Font2, 13);
  QTRCheckButton5Text:SetText(QTR_Interface.height2);
  local QTRCheckButton6 = CreateFrame("CheckButton", "QTRCheckButton6", QTROptions, "OptionsCheckButtonTemplate");
  QTRCheckButton6:SetPoint("TOPLEFT", QTRCheckButton5, "BOTTOMLEFT", 0, -5);
  QTRCheckButton6:SetScript("OnClick", function(self) QTR_ChangeFrameWidth(); QTRCheckButton7:SetChecked(QTR_PS["width"]=="2"); end);
  QTRCheckButton6Text:SetFont(QTR_Font2, 13);
  QTRCheckButton6Text:SetText(QTR_Interface.width1);
  local QTRCheckButton7 = CreateFrame("CheckButton", "QTRCheckButton7", QTROptions, "OptionsCheckButtonTemplate");
  QTRCheckButton7:SetPoint("TOPLEFT", QTRCheckButton6, "BOTTOMLEFT", 0, 5);
  QTRCheckButton7:SetScript("OnClick", function(self) QTR_ChangeFrameWidth(); QTRCheckButton6:SetChecked(QTR_PS["width"]=="1"); end);
  QTRCheckButton7Text:SetFont(QTR_Font2, 13);
  QTRCheckButton7Text:SetText(QTR_Interface.width2);
  
  local QTRCheckButtonGossip = CreateFrame("CheckButton", "QTRCheckButtonGossip", QTROptions, "OptionsCheckButtonTemplate");
  QTRCheckButtonGossip:SetPoint("TOPLEFT", QTRCheckButton7, "BOTTOMLEFT", -50, -50);
  QTRCheckButtonGossip:SetScript("OnClick", function(self) if (QTR_PS["gossip"]=="1") then QTR_PS["gossip"]="0" else QTR_PS["gossip"]="1" end; end);
  QTRCheckButtonGossipText:SetFont(QTR_Font2, 13);
  QTRCheckButtonGossipText:SetText("Wyświetlaj tłumaczenia tekstów GOSSIP");
  
  local QTRCheckButtonTutorial = CreateFrame("CheckButton", "QTRCheckButtonTutorial", QTROptions, "OptionsCheckButtonTemplate");
  QTRCheckButtonTutorial:SetPoint("TOPLEFT", QTRCheckButtonGossip, "BOTTOMLEFT", 0, -20);
  QTRCheckButtonTutorial:SetScript("OnClick", function(self) if (QTR_PS["tutorial"]=="1") then QTR_PS["tutorial"]="0" else QTR_PS["tutorial"]="1" end; end);
  QTRCheckButtonTutorialText:SetFont(QTR_Font2, 13);
  QTRCheckButtonTutorialText:SetText("Wyświetlaj tłumaczenia tekstów TUTORIAL");  
  
  local QTRWWW1 = QTROptions:CreateFontString(nil, "ARTWORK");
  QTRWWW1:SetFontObject(GameFontWhite);
  QTRWWW1:SetJustifyH("LEFT");
  QTRWWW1:SetJustifyV("TOP");
  QTRWWW1:ClearAllPoints();
  QTRWWW1:SetPoint("BOTTOMLEFT", 16, 16);
  QTRWWW1:SetFont(QTR_Font2, 13);
  QTRWWW1:SetText("Odwiedź stronę WWW dodatku:");
  
  local QTRWWW2 = CreateFrame("EditBox", "QTRWWW2", QTROptions, "InputBoxTemplate");
  QTRWWW2:ClearAllPoints();
  QTRWWW2:SetPoint("TOPLEFT", QTRWWW1, "TOPRIGHT", 10, 4);
  QTRWWW2:SetHeight(20);
  QTRWWW2:SetWidth(180);
  QTRWWW2:SetAutoFocus(false);
  QTRWWW2:SetFontObject(GameFontGreen);
  QTRWWW2:SetText("https://wowpopolsku.pl");
  QTRWWW2:SetCursorPosition(0);
  QTRWWW2:SetScript("OnEnter", function(self)
	  GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
      getglobal("GameTooltipTextLeft1"):SetFont(QTR_Font2, 13);
  	  GameTooltip:SetText("Kliknij i wciśnij CTRL+C, aby skopiować adres do schowka", nil, nil, nil, nil, true)
	  GameTooltip:Show() --Show the tooltip
     end);
  QTRWWW2:SetScript("OnLeave", function(self)
      getglobal("GameTooltipTextLeft1"):SetFont(Original_Font2, 13);
	  GameTooltip:Hide() --Hide the tooltip
     end);
  QTRWWW2:SetScript("OnTextChanged", function(self) QTRWWW2:SetText("https://wowpopolsku.pl"); end);
end


function QTR_OnLoad1()
  QTR.frame1 = CreateFrame("Frame");
  QTR.frame1:RegisterEvent("ADDON_LOADED");
  QTR.frame1:RegisterEvent("QUEST_LOG_UPDATE");
  QTR.frame1:SetScript("OnEvent", function(self, event, ...) return QTR[event] and QTR[event](QTR, event, ...) end);
  QuestLogDetailScrollFrame:SetScript("OnShow", QTR_ShowAndUpdateQuestInfo);
  QuestLogDetailScrollFrame:SetScript("OnHide", QTR_HideQuestInfo);

  QTR_QuestTitle:SetFont(QTR_Font2, 17);
  QTR_QuestDetail:SetFont(QTR_Font2, 14);
  QTRFrame1:ClearAllPoints();
  QTRFrame1:SetPoint("TOPLEFT", QuestLogFrame, "TOPRIGHT", -3, -12);

  -- small button in QuestLogFrame
  QTR_ToggleButton1 = CreateFrame("Button",nil, QuestLogFrame, "UIPanelButtonTemplate");
  QTR_ToggleButton1:SetWidth(35);
  QTR_ToggleButton1:SetHeight(18);
  QTR_ToggleButton1:SetText("QTR");
  QTR_ToggleButton1:Show();
  QTR_ToggleButton1:ClearAllPoints();
  QTR_ToggleButton1:SetPoint("TOPLEFT", QuestLogFrame, "TOPLEFT", 620, -15);
  QTR_ToggleButton1:SetScript("OnClick", QTR_ToggleVisibility);

  -- button for ChangeFrameHeight
  QTR_ToggleButton2 = CreateFrame("Button",nil, QTRFrame1, "UIPanelButtonTemplate");
  QTR_ToggleButton2:SetWidth(15);
  QTR_ToggleButton2:SetHeight(22);
  QTR_ToggleButton2:SetText("v");
  QTR_ToggleButton2:Show();
  QTR_ToggleButton2:ClearAllPoints();
  QTR_ToggleButton2:SetPoint("BOTTOMLEFT", QTRFrame1, "BOTTOMRIGHT", -40, 9);
  QTR_ToggleButton2:SetScript("OnClick", QTR_ChangeFrameHeight);

  -- button for ChangeFrameWidth
  QTR_ToggleButton3 = CreateFrame("Button",nil, QTRFrame1, "UIPanelButtonTemplate");
  QTR_ToggleButton3:SetWidth(15);
  QTR_ToggleButton3:SetHeight(22);
  QTR_ToggleButton3:SetText(">");
  QTR_ToggleButton3:Show();
  QTR_ToggleButton3:ClearAllPoints();
  QTR_ToggleButton3:SetPoint("BOTTOMLEFT", QTRFrame1, "BOTTOMRIGHT", -25, 9);
  QTR_ToggleButton3:SetScript("OnClick", QTR_ChangeFrameWidth);

  hooksecurefunc("QuestLogTitleButton_OnClick", function() QTR_UpdateQuestInfo() end);
  
   -- przycisk z nr HASH gossip w QuestMapDetailsScrollFrame
   --QTR_ToggleButtonGS = CreateFrame("Button",nil, GossipFrame, "UIPanelButtonTemplate");
   --QTR_ToggleButtonGS:SetWidth(230);
   --QTR_ToggleButtonGS:SetHeight(20);
   --QTR_ToggleButtonGS:SetText("Gossip-Hash=?");
   --QTR_ToggleButtonGS:Show();
   --QTR_ToggleButtonGS:ClearAllPoints();
   --QTR_ToggleButtonGS:SetPoint("TOPLEFT", GossipFrame, "TOPLEFT", 70, -50);
   --QTR_ToggleButtonGS:SetScript("OnClick", GS_ON_OFF);
end


function QTR_OnLoad2()
  QTR.frame2 = CreateFrame("Frame");
  QTR.frame2:RegisterEvent("QUEST_GREETING");
  QTR.frame2:RegisterEvent("QUEST_DETAIL");
  QTR.frame2:RegisterEvent("QUEST_PROGRESS");
  QTR.frame2:RegisterEvent("QUEST_COMPLETE");
  QTR.frame2:RegisterEvent("WORLD_MAP_UPDATE");
  --QTR.frame2:RegisterEvent("GOSSIP_SHOW");
  QTR.frame2:SetScript("OnEvent", function(self, event, ...) return QTR[event] and QTR[event](QTR, event, ...) end);
  QTR_QuestTitle2:SetFont(QTR_Font2, 17);
  QTR_QuestDetail2:SetFont(QTR_Font2, 14);
  QTR_QuestWarning2:SetFont(QTR_Font2, 12);
  QTRFrame2:ClearAllPoints();
  QTRFrame2:SetPoint("TOPLEFT", QuestFrame, "TOPRIGHT", -31, -19);
  QuestFrame:SetScript("OnHide", QTR_Frame2Close);
  hooksecurefunc("WorldMapQuestFrame_OnMouseUp", function() QTR_WorldMapQuestFrameOnMouseUp() end);
  --TutorialFrame:HookScript("OnShow", Tut_onTutorialShow);
  --TutorialFrameNextButton:HookScript("OnClick", Tut_onTutorialShow);
  --TutorialFramePrevButton:HookScript("OnClick", Tut_onTutorialShow);
end


function QTR_WorldMapQuestFrameOnMouseUp()
  QTR_event = "WORLD_MAP_OnMouseUp";
  QTR_OnEvent2();
end


function QTR_SlashCommand(msg)
  InterfaceOptionsFrame_OpenToCategory(QTROptions);
  RestoreOriginalFonts();
end


function QTR:ADDON_LOADED(_, addon)
  if (addon == "WoWpoPolsku_Quests") then
     SlashCmdList["WOWPOPOLSKU_QUESTS"] = function(msg) QTR_SlashCommand(msg); end
     SLASH_WOWPOPOLSKU_QUESTS1 = "/wowpopolsku-quests";
     SLASH_WOWPOPOLSKU_QUESTS2 = "/qtr";
     QTR_CheckVars();
     QTR_BlizzardOptions();
     if (DEFAULT_CHAT_FRAME) then
         DEFAULT_CHAT_FRAME:AddMessage("|cffffff00WoWpoPolsku-Quests ver. "..QTR_version.." - " .. QTR_Messages.loaded);
     else
         UIErrorsFrame:AddMessage("|cffffff00WoWpoPolsku-Quests ver. "..QTR_version.." - " .. QTR_Messages.loaded, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);
     end
     self.frame1:UnregisterEvent("ADDON_LOADED");
     self.ADDON_LOADED = nil;
     QTR_Messages.itemchoose1 = Spr_Gender(QTR_Messages.itemchoose1);
     if (not isGetQuestID) then
        DetectEmuServer();
     end;
  end
end


function QTR:QUEST_LOG_UPDATE()
  if (QTRFrame1:IsVisible()) then
     QTR_UpdateQuestInfo();
  end
end


function QTR:WORLD_MAP_UPDATE()
  if ( WorldMapFrame:IsVisible() ) then
     if (QTR_PS["active"]=="1") then
        if (QTR_PS["mode"]=="1") then
           if ( WorldMapQuestShowObjectives:GetChecked() ) then
              QTR_event = "WORLD_MAP_UPDATE";
              QTR_OnEvent2();
           end
	end
     end
  end
end


function QTR:GOSSIP_SHOW()
  if (QTR_PS["gossip"] == "1") then
     QTR_Gossip_Show();
  end
end  
    

function DetectEmuServer()
  QTR_PS["isGetQuestID"]="0";
  isGetQuestID="0";
  -- function GetQuestID() don't work on wow-emulator servers - possible lua error when you first start - not significant
  if ( GetQuestID() ) then
     QTR_PS["isGetQuestID"]="1";
     isGetQuestID="1";
  end
end


function QTR_wait(delay, func, ...)
  if(type(delay)~="number" or type(func)~="function") then
    return false;
  end
  if(QTR_waitFrame == nil) then
    QTR_waitFrame = CreateFrame("Frame","QTR_WaitFrame", UIParent);
    QTR_waitFrame:SetScript("onUpdate",function (self,elapse)
      local count = #QTR_waitTable;
      local i = 1;
      while(i<=count) do
        local waitRecord = tremove(QTR_waitTable,i);
        local d = tremove(waitRecord,1);
        local f = tremove(waitRecord,1);
        local p = tremove(waitRecord,1);
        if(d>elapse) then
          tinsert(QTR_waitTable,i,{d-elapse,f,p});
          i = i + 1;
        else
          count = count - 1;
          f(unpack(p));
        end
      end
    end);
  end
  tinsert(QTR_waitTable,{delay,func,{...}});
  return true;
end


function QTR:QUEST_GREETING()
  if (QTR_PS["active"]=="1" and QTR_PS["mode"]=="1") then
     CurrentQuestsText:SetText(QTR_Messages.currquests);
     CurrentQuestsText:SetFont(QTR_Font1, 18);
     AvailableQuestsText:SetText(QTR_Messages.avaiquests);
     AvailableQuestsText:SetFont(QTR_Font1, 18);
  else
     CurrentQuestsText:SetText(QTR_MessOrig.currquests);
     CurrentQuestsText:SetFont(Original_Font1, 18);
     AvailableQuestsText:SetText(QTR_MessOrig.avaiquests);
     AvailableQuestsText:SetFont(Original_Font1, 18);
  end
end


function QTR:QUEST_DETAIL()
  QTR_event = "QUEST_DETAIL";
  if (isGetQuestID=="0") then
     if ( not QTR_wait(1,QTR_OnEvent2) ) then
        QTR_OnEvent2();
     end
  else
     QTR_OnEvent2();
  end
end


function QTR:QUEST_PROGRESS()
  QTR_event = "QUEST_PROGRESS";
  QTR_OnEvent2();
end


function QTR:QUEST_COMPLETE()
  QTR_event = "QUEST_COMPLETE";
  QTR_OnEvent2();
end


function QTR_OnEvent2()
  local q_ID = 0;
  local q_title = GetTitleText();
  local q_i = 1;

  if ( WorldMapFrame:IsVisible() ) then
    for i = 1, MAX_NUM_QUESTS do
      questFrame = _G["WorldMapQuestFrame"..i];
      if ( not questFrame ) then
        break
      elseif ( WORLDMAP_SETTINGS.selectedQuest==questFrame ) then
        q_title=questFrame.title:GetText();
        break;
      end
    end
  end

  -- search in QuestLog
  while GetQuestLogTitle(q_i) do
    local questTitle, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily, questID = GetQuestLogTitle(q_i)
    if ( not isHeader ) then
       if ( q_title == questTitle ) then
          q_ID=questID;
          break;
       end
    end
    q_i = q_i + 1;
  end
  RestoreOriginalFonts();
  if ( QTR_PS["active"]=="1" )then
     QTR_QuestID2:SetText("");
     QTR_QuestTitle2:SetText(q_title);
     QTR_QuestDetail2:SetText(QTR_Messages.missing);
     QTR_QuestWarning2:SetText("");
     -- not exist in QuestLog ?
     if ( q_ID == 0 ) then
        if ( isGetQuestID=="1" ) then
           q_ID = GetQuestID();
        end
        if ( q_ID == 0 ) then
           if (QTR_QuestList[q_title]) then
              local q_lists=QTR_QuestList[q_title];
              q_i=string.find(q_lists, ",");
              if ( string.find(q_lists, ",")==nil ) then
                 -- only 1 questID to this title
                 q_ID=tonumber(q_lists);
              else
                 -- multiple questIDs - get first, available (not completed) questID from QuestLists
                 local QTR_table=QTR_split(q_lists, ",");
                 local QTR_multiple = "";
                 local QTR_Center="";
                 for ii,vv in ipairs(QTR_table) do
                    if (not QTR_PC[vv]) then
                       if (QTR_Center=="") then
                           QTR_Center=vv;
                       else
                           QTR_multiple = QTR_multiple .. ", " .. vv;
                       end
                    end
                 end
                 if ( string.len(QTR_Center)>0 ) then
                    q_ID=tonumber(QTR_Center);
                    if ( string.len(QTR_multiple)>0 ) then
                       QTR_multiple = " (" .. string.sub(QTR_multiple, 3) .. ")";
                       QTR_QuestWarning2:SetText(QTR_Messages.multipleID .. QTR_multiple);
                    end
                 end
              end
           end
        end
     end
     if ( q_ID > 0 ) then
        local str_id = tostring(q_ID);
        QTR_QuestID2:SetText("QuestID: " .. str_id);
        QTR_QuestTitle2:SetText(q_title);
        if (QTR_QuestData[str_id]) then
           -- display only, if translation exists
	   if (QTR_PS["mode"]=="2") then
              QTR_ShowFrame2(QTR_event, str_id);
	   else
              QTR_ChangeText_InEvent(QTR_event, str_id);
           end
        else
           -- DEFAULT_CHAT_FRAME:AddMessage("WoWpoPolsku-Quests - Qid: "..tostring(q_ID).." ("..QTR_Messages.missing..")");
           QTR_SAVED[str_id.." TITLE"]=GetTitleText();               -- save original title to future translation
           if (QTR_event=="QUEST_DETAIL") then
              QTR_SAVED[str_id.." DESCRIPTION"]=GetQuestText();      -- save original text to future translation
              QTR_SAVED[str_id.." OBJECTIVE"]=GetObjectiveText();    -- save original text to future translation
           end
           if (QTR_event=="QUEST_PROGRESS") then
              QTR_SAVED[str_id.." PROGRESS"]=GetProgressText();      -- save original text to future translation
           end
           if (QTR_event=="QUEST_COMPLETE") then
              QTR_SAVED[str_id.." COMPLETE"]=GetRewardText();        -- save original text to future translation
           end
           QTRFrame2:Hide();
        end
     end
  end
  if (QTR_event == "QUEST_COMPLETE") then
     if ( q_ID > 0) then
        local str_id = tostring(q_ID);
        QTR_PC[str_id]="OK";
     end
  end
end


function QTR_ShowFrame2(eventStr, qid)
  QTR_QuestID2:SetText("QuestID: " .. qid);
  QTR_QuestDetail2:SetText(QTR_Messages.missing);
  if (QTR_QuestData[qid]) then
     QTR_QuestTitle2:SetText(QTR_ExpandUnitInfo(QTR_QuestData[qid]["Title"]));
     local QTR_text = "";
     if (eventStr == "QUEST_DETAIL") then
        if (QTR_QuestData[qid]["Description"]) then
           QTR_text = QTR_ExpandUnitInfo(QTR_QuestData[qid]["Description"]);
        end
        local QTR_text2 = "";
        if (QTR_QuestData[qid]["Objectives"]) then
           QTR_text2 = QTR_ExpandUnitInfo(QTR_QuestData[qid]["Objectives"]);
        end
        QTR_text = QTR_text .. "\n\n" .. QTR_Messages.objectives .. "\n" .. QTR_text2;
     end
     if (eventStr == "QUEST_PROGRESS") then
        if (QTR_QuestData[qid]["Progress"]) then
           QTR_text = QTR_ExpandUnitInfo(QTR_QuestData[qid]["Progress"]);
        end
     end
     if (eventStr == "QUEST_COMPLETE") then
        if (QTR_QuestData[qid]["Completion"]) then
           QTR_text = QTR_ExpandUnitInfo(QTR_QuestData[qid]["Completion"]);
        end
     end
     QTR_QuestDetail2:SetText(QTR_text);
     QTRFrame2:ClearAllPoints();
     QTRFrame2:SetPoint("TOPLEFT", QuestFrame, "TOPRIGHT", -31, -19);
     if ( QuestNPCModel ) then
        if ( QuestNPCModel:IsVisible() ) then
           QTRFrame2:SetPoint("TOPLEFT", QuestNPCModel, "TOPRIGHT", 0, 42);
        end
     end
     QTRFrame2:Show();
  end
end


function QTR_Frame2Close()
  QTRFrame2:Hide();
  QuestFrame_OnHide();
end


function QTR_split(str, c)
  local aCount = 0;
  local array = {};
  local a = string.find(str, c);
  while a do
     aCount = aCount + 1;
     array[aCount] = string.sub(str, 1, a-1);
     str=string.sub(str, a+1);
     a = string.find(str, c);
  end
  aCount = aCount + 1;
  array[aCount] = str;
  return array;
end


function QTR_findlast(source, char)
  if (not source) then
     return 0;
  end
  local lastpos = 0;
  local byte_char = string.byte(char);
  for i=1, #source do
     if (string.byte(source,i)==byte_char) then
        lastpos = i;
     end
  end
  return lastpos;
end


function QTR_ChangeFrameHeight()
  -- normal height of Frame = 425, quest detail = 350
  if (QTR_SizeH == 1) then
     QTRFrame1:SetHeight(525);
     QTR_QuestDetail:SetHeight(430);
     QTR_ToggleButton2:SetText("^");
     QTR_SizeH = 2;
     QTR_PS["size"] = "2";
  else
     QTRFrame1:SetHeight(425);
     QTR_QuestDetail:SetHeight(350);
     QTR_ToggleButton2:SetText("v");
     QTR_SizeH = 1;
     QTR_PS["size"] = "1";
  end
end


function QTR_ChangeFrameWidth()
  -- normal width of Frame = 350, quest detail = 320
  if (QTR_SizeW == 1) then
     QTRFrame1:SetWidth(525);
     QTR_QuestDetail:SetWidth(495);
     QTR_QuestTitle:SetWidth(495);
     QTR_ToggleButton3:SetText("<");
     QTR_SizeW = 2;
     QTR_PS["width"] = "2";
  else
     QTRFrame1:SetWidth(350);
     QTR_QuestDetail:SetWidth(320);
     QTR_QuestTitle:SetWidth(320);
     QTR_ToggleButton3:SetText(">");
     QTR_SizeW = 1;
     QTR_PS["width"] = "1";
  end
end


function QTR_OnMouseDown1()
  -- start moving the window
  QTRFrame1:StartMoving();
end
  

function QTR_OnMouseUp1()
  -- stop moving the window
  QTRFrame1:StopMovingOrSizing();
end


function QTR_OnMouseDown2()
  -- start moving the window
  QTRFrame2:StartMoving();
end
  

function QTR_OnMouseUp2()
  -- stop moving the window
  QTRFrame2:StopMovingOrSizing();
end


function RestoreOriginalFonts()
  QuestInfoTitleHeader:SetFont(Original_Font1, 18);
  QuestInfoDescriptionHeader:SetText(QTR_MessOrig.details);
  QuestInfoDescriptionHeader:SetFont(Original_Font1, 18);
  QuestInfoDescriptionText:SetFont(Original_Font2, 13);
  QuestInfoObjectivesHeader:SetText(QTR_MessOrig.objectives);
  QuestInfoObjectivesHeader:SetFont(Original_Font1, 18);
  QuestInfoObjectivesText:SetFont(Original_Font2, 13);
  QuestInfoRewardsHeader:SetText(QTR_MessOrig.rewards);
  QuestInfoRewardsHeader:SetFont(Original_Font1, 18);
  QuestInfoRewardText:SetFont(Original_Font2, 13);
  --QuestInfoItemChooseText:SetText(QTR_MessOrig.itemchoose1);
  --QuestInfoItemChooseText:SetFont(Original_Font2, 13);
  --QuestInfoItemReceiveText:SetText(QTR_MessOrig.itemreceiv1);
  --QuestInfoItemReceiveText:SetFont(Original_Font2, 13);
  QuestInfoXPFrameReceiveText:SetText(QTR_MessOrig.experience);
  QuestInfoXPFrameReceiveText:SetFont(Original_Font2, 13);
  QuestInfoRequiredMoneyText:SetText(QTR_MessOrig.reqmoney);
  QuestInfoRequiredMoneyText:SetFont(Original_Font2, 13);
  QuestInfoSpellLearnText:SetText(QTR_MessOrig.learnspell);
  QuestInfoSpellLearnText:SetFont(Original_Font2, 13);
  QuestProgressTitleText:SetFont(Original_Font1, 18);
  QuestProgressText:SetFont(Original_Font2, 13);
  QuestProgressRequiredItemsText:SetText(QTR_MessOrig.reqitems);
  QuestProgressRequiredItemsText:SetFont(Original_Font1, 18);
  QuestProgressRequiredMoneyText:SetText(QTR_MessOrig.reqmoney);
  QuestProgressRequiredMoneyText:SetFont(Original_Font2, 13);
end


function QTR_ChangeText_InEvent(QTR_event, str_id)
  if (QTR_PS["transtitle"]=="1") then
     QuestInfoTitleHeader:SetText(QTR_ExpandUnitInfo(QTR_QuestData[str_id]["Title"]));
     QuestInfoTitleHeader:SetFont(QTR_Font1, 18);
     QuestProgressTitleText:SetText(QTR_ExpandUnitInfo(QTR_QuestData[str_id]["Title"]));
     QuestProgressTitleText:SetFont(QTR_Font1, 18);
  end
  QuestInfoDescriptionHeader:SetText(QTR_Messages.details);
  QuestInfoDescriptionHeader:SetFont(QTR_Font1, 18);
  QuestInfoDescriptionText:SetText(QTR_ExpandUnitInfo(QTR_QuestData[str_id]["Description"]));
  QuestInfoDescriptionText:SetFont(QTR_Font2, 13);
  QuestInfoObjectivesHeader:SetText(QTR_Messages.objectives);
  QuestInfoObjectivesHeader:SetFont(QTR_Font1, 18);
  QuestInfoObjectivesText:SetText(QTR_ExpandUnitInfo(QTR_QuestData[str_id]["Objectives"]));
  QuestInfoObjectivesText:SetFont(QTR_Font2, 13);
  QuestInfoRewardsHeader:SetText(QTR_Messages.rewards);
  QuestInfoRewardsHeader:SetFont(QTR_Font1, 18);
  QuestInfoRewardText:SetText(QTR_ExpandUnitInfo(QTR_QuestData[str_id]["Completion"]));
  QuestInfoRewardText:SetFont(QTR_Font2, 13);
  if (QTR_event=="QUEST_COMPLETE") then
     QuestInfoItemChooseText:SetText(QTR_Messages.itemchoose2);
     QuestInfoItemReceiveText:SetText(QTR_Messages.itemreceiv2);
  else
     QuestInfoItemChooseText:SetText(QTR_Messages.itemchoose1);
     QuestInfoItemReceiveText:SetText(QTR_Messages.itemreceiv1);
  end
  QuestInfoItemChooseText:SetFont(QTR_Font2, 13);
  QuestInfoItemReceiveText:SetFont(QTR_Font2, 13);
  QuestInfoXPFrameReceiveText:SetText(QTR_Messages.experience);
  QuestInfoXPFrameReceiveText:SetFont(QTR_Font2, 13);
  QuestInfoRequiredMoneyText:SetText(QTR_Messages.reqmoney);
  QuestInfoRequiredMoneyText:SetFont(QTR_Font2, 13);
  QuestInfoSpellLearnText:SetText(QTR_Messages.learnspell);
  QuestInfoSpellLearnText:SetFont(QTR_Font2, 13);
  QuestProgressText:SetText(QTR_ExpandUnitInfo(QTR_QuestData[str_id]["Progress"]));
  QuestProgressText:SetFont(QTR_Font2, 13);
  QuestProgressRequiredMoneyText:SetText(QTR_Messages.reqmoney);
  QuestProgressRequiredMoneyText:SetFont(QTR_Font2, 13);
  QuestProgressRequiredItemsText:SetText(QTR_Messages.reqitems);
  QuestProgressRequiredItemsText:SetFont(QTR_Font1, 18);
end


function QTR_ChangeText_OnQuestLog(qid)
  if (QTR_PS["transtitle"]=="1") then
     QuestInfoTitleHeader:SetText(QTR_ExpandUnitInfo(QTR_QuestData[qid]["Title"]));
     QuestInfoTitleHeader:SetFont(QTR_Font1, 18);
  end
  QuestInfoDescriptionHeader:SetText(QTR_Messages.details);
  QuestInfoDescriptionHeader:SetFont(QTR_Font1, 18);
  QuestInfoDescriptionText:SetText(QTR_description);
  QuestInfoDescriptionText:SetFont(QTR_Font2, 13);
  QuestInfoObjectivesHeader:SetText(QTR_Messages.objectives);
  QuestInfoObjectivesHeader:SetFont(QTR_Font1, 18);
  QuestInfoObjectivesText:SetText(QTR_objectives);
  QuestInfoObjectivesText:SetFont(QTR_Font2, 13);
  QuestInfoRewardsHeader:SetText(QTR_Messages.rewards);
  QuestInfoRewardsHeader:SetFont(QTR_Font1, 18);
  --QuestInfoRewardText:SetText(QTR_ExpandUnitInfo(QTR_QuestData[qid]["Completion"]));
  --QuestInfoRewardText:SetFont(QTR_Font2, 13);
  QuestInfoItemChooseText:SetText(QTR_Messages.itemchoose1);
  QuestInfoItemChooseText:SetFont(QTR_Font2, 13);
  QuestInfoItemReceiveText:SetText(QTR_Messages.itemreceiv1);
  QuestInfoItemReceiveText:SetFont(QTR_Font2, 13);
  QuestInfoXPFrameReceiveText:SetText(QTR_Messages.experience);
  QuestInfoXPFrameReceiveText:SetFont(QTR_Font2, 13);
  QuestInfoRequiredMoneyText:SetText(QTR_Messages.reqmoney);
  QuestInfoRequiredMoneyText:SetFont(QTR_Font2, 13);
  QuestInfoSpellLearnText:SetText(QTR_Messages.learnspell);
  QuestInfoSpellLearnText:SetFont(QTR_Font2, 13);
end


function QTR_ToggleVisibility()
  -- click on QTR button in QuestLogFrame
  if (QTR_PS["active"]=="0") then
     QTR_PS["active"] = "1";
     QTR_ShowAndUpdateQuestInfo();
     if (DEFAULT_CHAT_FRAME) then
         DEFAULT_CHAT_FRAME:AddMessage("|cffffff00WoWpoPolsku-Quests "..QTR_Messages.isactive);
     else
         UIErrorsFrame:AddMessage("|cffffff00WoWpoPolsku-Quests "..QTR_Messages.isactive, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);
     end
  else
     QTR_PS["active"] = "0";
     QTR_HideQuestInfo();
     if (DEFAULT_CHAT_FRAME) then
         DEFAULT_CHAT_FRAME:AddMessage("|cffffff00WoWpoPolsku-Quests "..QTR_Messages.isinactive);
     else
         UIErrorsFrame:AddMessage("|cffffff00WoWpoPolsku-Quests "..QTR_Messages.isinactive, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);
     end
     RestoreOriginalFonts();
  end
end


function QTR_ShowAndUpdateQuestInfo()
  if (QTR_PS["active"]=="0") then
     return;
  end
  if (QTR_PS["mode"]=="2") then
     QTRFrame1:Show();
  end;
  QTR_UpdateQuestInfo();
end


function QTR_HideQuestInfo()
  QTRFrame1:Hide();
end


function QTR_UpdateQuestInfo()
  if (QTR_PS["active"]=="0") then
     return;
  end
  local questSelected = GetQuestLogSelection();
  if (GetQuestLogTitle(questSelected) == nil) then
     return;
  end

  local questTitle, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily, questID = GetQuestLogTitle(questSelected);
  if (isHeader) then
     return;
  end

  local qid = tostring(questID);
  QTR_QuestID:SetText("QuestID: " .. qid);

  if (QTR_QuestData[qid]) then
     QTR_objectives  = QTR_ExpandUnitInfo(QTR_QuestData[qid]["Objectives"]);
     QTR_description = QTR_ExpandUnitInfo(QTR_QuestData[qid]["Description"]);
     QTR_descripFull = QTR_Messages.details .. "\n" .. QTR_description;
     QTR_translator = "";
     if (QTR_QuestData[qid]["Translator"]) then
        if (QTR_QuestData[qid]["Translator"]>"") then
            QTR_translator = "\n\n" .. QTR_Messages.translator .. " " .. QTR_ExpandUnitInfo(QTR_QuestData[qid]["Translator"]);
        end
     end
     QTR_QuestTitle:SetText(QTR_ExpandUnitInfo(QTR_QuestData[qid]["Title"]));
     QTR_QuestDetail:SetText(QTR_objectives .. "\n\n" .. QTR_descripFull .. QTR_translator);
     if (QTR_PS["mode"]=="1") then		       -- translation direct into original QuestLog frame
        QTR_ChangeText_OnQuestLog(qid);
     end
  else
     QTR_QuestTitle:SetText(questTitle);
     QTR_QuestDetail:SetText(QTR_Messages.missing);
     if (QTR_PS["mode"]=="1") then
	RestoreOriginalFonts();
     end;
  end 
end


function GS_ON_OFF()
   if (curr_goss=="1") then         -- wyłącz tłumaczenie - pokaż oryginalny tekst
      curr_goss="0";
      GossipGreetingText:SetText(QTR_GS[curr_hash]);
      GossipGreetingText:SetFont(Original_Font2, 13);      
      QTR_ToggleButtonGS:SetText("Gossip-Hash=["..tostring(curr_hash).."] EN");
   else                             -- pokaż tłumaczenie PL
      curr_goss="1";
      local Greeting_PL = GS_Gossip[curr_hash];
      GossipGreetingText:SetText(QTR_ExpandUnitInfo(Greeting_PL));
      GossipGreetingText:SetFont(QTR_Font2, 13);      
      QTR_ToggleButtonGS:SetText("Gossip-Hash=["..tostring(curr_hash).."] PL");
   end
end


-- Otworzono okienko rozmowy z NPC
function QTR_Gossip_Show()
   local Nazwa_NPC = GossipFrameNpcNameText:GetText();
   curr_hash = 0;
   if (Nazwa_NPC) then
      local Greeting_Text = GossipGreetingText:GetText();
      if (string.find(Greeting_Text," ")==nil) then         -- nie jest to tekst po polsku (nie ma twardej spacji)
         Nazwa_NPC = string.gsub(Nazwa_NPC, '"', '\"');
         Greeting_Text = string.gsub(Greeting_Text, '"', '\"');
         local Czysty_Text = string.gsub(Greeting_Text, '\r', '');
         Czysty_Text = string.gsub(Czysty_Text, '\n', '$B');
         Czysty_Text = string.gsub(Czysty_Text, QTR_name, '$N');
         Czysty_Text = string.gsub(Czysty_Text, string.upper(QTR_name), '$N$');
         Czysty_Text = string.gsub(Czysty_Text, QTR_race, '$R');
         Czysty_Text = string.gsub(Czysty_Text, string.lower(QTR_race), '$R');
         Czysty_Text = string.gsub(Czysty_Text, QTR_class, '$C');
         Czysty_Text = string.gsub(Czysty_Text, string.lower(QTR_class), '$C');
         Czysty_Text = string.gsub(Czysty_Text, '$N$', '');
         Czysty_Text = string.gsub(Czysty_Text, '$N', '');
         Czysty_Text = string.gsub(Czysty_Text, '$B', '');
         Czysty_Text = string.gsub(Czysty_Text, '$R', '');
         Czysty_Text = string.gsub(Czysty_Text, '$C', '');
         local Hash = StringHash(Czysty_Text);
         curr_hash = Hash;
         QTR_GS[Hash] = Greeting_Text;                      -- zapis oryginalnego tekstu
         if ( GS_Gossip[Hash] ) then   -- istnieje tłumaczenie tekstu GOSSIP tego NPC
            curr_goss = "1";
            local Greeting_PL = GS_Gossip[Hash];
            GossipGreetingText:SetText(QTR_ExpandUnitInfo(Greeting_PL));
            GossipGreetingText:SetFont(QTR_Font2, 13);
            QTR_ToggleButtonGS:SetText("Gossip-Hash=["..tostring(Hash).."] PL");
            QTR_ToggleButtonGS:Enable();
         else                               -- nie ma tłumaczenia w bazie GOSSIP
            curr_goss = "0";
            -- zapis do pliku
            QTR_GOSSIP[Nazwa_NPC.."@"..tostring(Hash)] = Greeting_Text.."@"..QTR_name..":"..QTR_race..":"..QTR_class;
            QTR_ToggleButtonGS:SetText("Gossip-Hash=["..tostring(Hash).."] EN");
            QTR_ToggleButtonGS:Disable();
         end
         if (GetNumGossipOptions()>0) then    -- są jeszcze przyciski funkcji dodatkowych
         --   local pozycja=GetNumGossipActiveQuests()+GetNumGossipAvailableQuests()+1;
            local pozycja=0;
            local titleButton;
            for i = 1, GetNumGossipOptions(), 1 do 
               titleButton=getglobal("GossipTitleButton"..tostring(pozycja+i));
               if (titleButton:GetText()) then
                  local gostxt = titleButton:GetText();
                  if (string.find(gostxt, "|cff000000") == nil) then   -- nie jest to quest w gossip
                     Hash = StringHash(gostxt);
                     if ( GS_Gossip[Hash] ) then   -- istnieje tłumaczenie tekstu dodatkowego
                        titleButton:SetText(QTR_ExpandUnitInfo(GS_Gossip[Hash]));
                        titleButton:GetFontString():SetFont(QTR_Font2, 13);
                     else
                        QTR_GOSSIP[Nazwa_NPC..'@'..tostring(Hash)] = gostxt.."@"..QTR_name..":"..QTR_race..":"..QTR_class;
                     end
                  end
               end
            end
         end
      end
   end
end


function Tut_onTutorialShow()
   if (QTR_PS["tutorial"]=="1") then
      if (not QTR_wait(0.1,Tut_TutorialShowDelayed)) then
         -- opóźnienie 0.1 sek
      end
   end
end


function Tut_TutorialShowDelayed()
   Tut_ID = TutorialFrame.id;
   local Tut_tytul, Tut_tekst = "","";
   if (Tut_Data[tostring(Tut_ID).."_"..Tut_race.."_"..Tut_class]) then    -- jest tłumaczenie PL
      Tut_tytul = Tut_Data[tostring(Tut_ID).."_"..Tut_race.."_"..Tut_class]["Title"];
      Tut_tekst = Tut_Data[tostring(Tut_ID).."_"..Tut_race.."_"..Tut_class]["Text"];
   elseif (Tut_Data[tostring(Tut_ID).."_"..Tut_class]) then
      Tut_tytul = Tut_Data[tostring(Tut_ID).."_"..Tut_class]["Title"];
      Tut_tekst = Tut_Data[tostring(Tut_ID).."_"..Tut_class]["Text"];
   elseif (Tut_Data[tostring(Tut_ID).."_"..Tut_race]) then
      Tut_tytul = Tut_Data[tostring(Tut_ID).."_"..Tut_race]["Title"];
      Tut_tekst = Tut_Data[tostring(Tut_ID).."_"..Tut_race]["Text"];
   elseif (Tut_Data[tostring(Tut_ID).."_A"]) then
      Tut_tytul = Tut_Data[tostring(Tut_ID).."_A"]["Title"];
      Tut_tekst = Tut_Data[tostring(Tut_ID).."_A"]["Text"];
   elseif (Tut_Data[tostring(Tut_ID)]) then
      Tut_tytul = Tut_Data[tostring(Tut_ID)]["Title"];
      Tut_tekst = Tut_Data[tostring(Tut_ID)]["Text"];
   end    
   if (string.len(Tut_tekst)>0) then
      TutorialFrameTitle:SetText(Tut_tytul);
      local _font1, _size1, _1 = TutorialFrameTitle:GetFont();
      TutorialFrameTitle:SetFont(QTR_Font2, _size1);
      TutorialFrameText:SetText(Tut_tekst);
      local _font2, _size2, _2 = TutorialFrameText:GetFont();
      TutorialFrameText:SetFont(QTR_Font2, _size2);  
   end
   TutorialFrameOkayButton:SetText("Zamknij");
end


function QTR_ExpandUnitInfo(msg)
   msg = string.gsub(msg, "NEW_LINE", "\n");
   msg = string.gsub(msg, "YOUR_NAME0", string.upper(QTR_name));
   msg = string.gsub(msg, "YOUR_NAME1", QTR_name);
   msg = string.gsub(msg, "YOUR_NAME2", QTR_name);
   msg = string.gsub(msg, "YOUR_NAME3", QTR_name);
   msg = string.gsub(msg, "YOUR_NAME4", QTR_name);
   msg = string.gsub(msg, "YOUR_NAME5", QTR_name);
   msg = string.gsub(msg, "YOUR_NAME6", QTR_name);
   msg = string.gsub(msg, "YOUR_NAME7", QTR_name);
   msg = string.gsub(msg, "YOUR_NAME", QTR_name);
   
-- jeszcze obsłużyć YOUR_GENDER(x;y)
   local nr_1, nr_2, nr_3 = 0;
   local QTR_forma = "";
   local nr_poz = string.find(msg, "YOUR_GENDER");    -- gdy nie znalazł, jest: nil
   while (nr_poz and nr_poz>0) do
      nr_1 = nr_poz + 1;   
      while (string.sub(msg, nr_1, nr_1) ~= "(") do
         nr_1 = nr_1 + 1;
      end
      if (string.sub(msg, nr_1, nr_1) == "(") then
         nr_2 =  nr_1 + 1;
         while (string.sub(msg, nr_2, nr_2) ~= ";") do
            nr_2 = nr_2 + 1;
         end
         if (string.sub(msg, nr_2, nr_2) == ";") then
            nr_3 = nr_2 + 1;
            while (string.sub(msg, nr_3, nr_3) ~= ")") do
               nr_3 = nr_3 + 1;
            end
            if (string.sub(msg, nr_3, nr_3) == ")") then
               if (QTR_sex==3) then        -- forma żeńska
                  QTR_forma = string.sub(msg,nr_2+1,nr_3-1);
               else                        -- forma męska
                  QTR_forma = string.sub(msg,nr_1+1,nr_2-1);
               end
               msg = string.sub(msg,1,nr_poz-1) .. QTR_forma .. string.sub(msg,nr_3+1);
            end   
         end
      end
      nr_poz = string.find(msg, "YOUR_GENDER");
   end

-- jeszcze obsłużyć YOUR_GENDER(x;y)
   local nr_1, nr_2, nr_3 = 0;
   local QTR_forma = "";
   local nr_poz = string.find(msg, "YOUR_GENDER");    -- gdy nie znalazł, jest: nil
   while (nr_poz and nr_poz>0) do
      nr_1 = nr_poz + 1;   
      while (string.sub(msg, nr_1, nr_1) ~= "(") do
         nr_1 = nr_1 + 1;
      end
      if (string.sub(msg, nr_1, nr_1) == "(") then
         nr_2 =  nr_1 + 1;
         while (string.sub(msg, nr_2, nr_2) ~= ";") do
            nr_2 = nr_2 + 1;
         end
         if (string.sub(msg, nr_2, nr_2) == ";") then
            nr_3 = nr_2 + 1;
            while (string.sub(msg, nr_3, nr_3) ~= ")") do
               nr_3 = nr_3 + 1;
            end
            if (string.sub(msg, nr_3, nr_3) == ")") then
               if (QTR_sex==3) then        -- forma żeńska
                  QTR_forma = string.sub(msg,nr_2+1,nr_3-1);
               else                        -- forma męska
                  QTR_forma = string.sub(msg,nr_1+1,nr_2-1);
               end
               msg = string.sub(msg,1,nr_poz-1) .. QTR_forma .. string.sub(msg,nr_3+1);
            end   
         end
      end
      nr_poz = string.find(msg, "YOUR_GENDER");
   end

-- jeszcze obsłużyć NPC_GENDER(x;y)
   local nr_1, nr_2, nr_3 = 0;
   local QTR_forma = "";
   local NPC_sex = UnitSex("npc");     -- 1:neutral,  2:męski,  3:żeński
   local nr_poz = string.find(msg, "NPC_GENDER");    -- gdy nie znalazł, jest: nil
   while (nr_poz and nr_poz>0) do
      nr_1 = nr_poz + 1;   
      while (string.sub(msg, nr_1, nr_1) ~= "(") do
         nr_1 = nr_1 + 1;
      end
      if (string.sub(msg, nr_1, nr_1) == "(") then
         nr_2 =  nr_1 + 1;
         while (string.sub(msg, nr_2, nr_2) ~= ";") do
            nr_2 = nr_2 + 1;
         end
         if (string.sub(msg, nr_2, nr_2) == ";") then
            nr_3 = nr_2 + 1;
            while (string.sub(msg, nr_3, nr_3) ~= ")") do
               nr_3 = nr_3 + 1;
            end
            if (string.sub(msg, nr_3, nr_3) == ")") then
               if (NPC_sex==3) then        -- forma żeńska
                  QTR_forma = string.sub(msg,nr_2+1,nr_3-1);
               else                        -- forma męska
                  QTR_forma = string.sub(msg,nr_1+1,nr_2-1);
               end
               msg = string.sub(msg,1,nr_poz-1) .. QTR_forma .. string.sub(msg,nr_3+1);
            end   
         end
      end
      nr_poz = string.find(msg, "NPC_GENDER");
   end

   if (QTR_sex==3) then        -- płeć żeńska
      msg = string.gsub(msg, "YOUR_CLASS1", player_class.M2);          -- Mianownik (kto, co?)
      msg = string.gsub(msg, "YOUR_CLASS2", player_class.D2);          -- Dopełniacz (kogo, czego?)
      msg = string.gsub(msg, "YOUR_CLASS3", player_class.C2);          -- Celownik (komu, czemu?)
      msg = string.gsub(msg, "YOUR_CLASS4", player_class.B2);          -- Biernik (kogo, co?)
      msg = string.gsub(msg, "YOUR_CLASS5", player_class.N2);          -- Narzędnik (z kim, z czym?)
      msg = string.gsub(msg, "YOUR_CLASS6", player_class.K2);          -- Miejscownik (o kim, o czym?)
      msg = string.gsub(msg, "YOUR_CLASS7", player_class.W2);          -- Wołacz (o!)
      msg = string.gsub(msg, "YOUR_RACE1", player_race.M2);            -- Mianownik (kto, co?)
      msg = string.gsub(msg, "YOUR_RACE2", player_race.D2);            -- Dopełniacz (kogo, czego?)
      msg = string.gsub(msg, "YOUR_RACE3", player_race.C2);            -- Celownik (komu, czemu?)
      msg = string.gsub(msg, "YOUR_RACE4", player_race.B2);            -- Biernik (kogo, co?)
      msg = string.gsub(msg, "YOUR_RACE5", player_race.N2);            -- Narzędnik (kim, czym?)
      msg = string.gsub(msg, "YOUR_RACE6", player_race.K2);            -- Miejscownik (o kim, o czym?)
      msg = string.gsub(msg, "YOUR_RACE7", player_race.W2);            -- Wołacz (o!)
      msg = string.gsub(msg, "YOUR_RACE YOUR_CLASS", "YOUR_RACE "..player_class.M2);     -- Mianownik (kto, co?)
      msg = string.gsub(msg, "ą YOUR_RACE", "ą "..player_race.N2);              -- Narzędnik (kim, czym?)
      msg = string.gsub(msg, " jesteś YOUR_RACE", " jesteś "..player_race.N2);    -- Narzędnik (kim, czym?)
      msg = string.gsub(msg, "YOUR_RACE", player_race.W2);                        -- Wołacz - pozostałe wystąpienia
      msg = string.gsub(msg, "ą YOUR_CLASS", "ą "..player_class.N2);            -- Narzędnik (kim, czym?)
      msg = string.gsub(msg, "esteś YOUR_CLASS", "esteś "..player_class.N2);      -- Narzędnik (kim, czym?)
      msg = string.gsub(msg, " z Ciebie YOUR_CLASS", " z Ciebie "..player_class.M2);    -- Mianownik (kto, co?)
      msg = string.gsub(msg, " kolejny YOUR_CLASS do ", " kolejny "..player_class.M2.." do ");   -- Mianownik (kto, co?)
      msg = string.gsub(msg, " taki YOUR_CLASS", " taki "..player_class.M2);      -- Mianownik (kto, co?)
      msg = string.gsub(msg, "ako YOUR_CLASS", "ako "..player_class.M2);          -- Mianownik (kto, co?)
      msg = string.gsub(msg, " co sprowadza YOUR_CLASS", " co sprowadza "..player_class.B2);     -- Biernik (kogo, co?)
      msg = string.gsub(msg, " będę miał YOUR_CLASS", " będę miał "..player_class.B2);  -- Biernik (kogo, co?)
      msg = string.gsub(msg, "YOUR_CLASS taki jak ", player_class.B2.." taki jak ");    -- Biernik (kogo, co?)
      msg = string.gsub(msg, " jak na YOUR_CLASS", " jak na "..player_class.B2);        -- Biernik (kogo, co?)
      msg = string.gsub(msg, "YOUR_CLASS", player_class.W2);                      -- Wołacz - pozostałe wystąpienia
   else                    -- płeć męska
      msg = string.gsub(msg, "YOUR_CLASS1", player_class.M1);          -- Mianownik (kto, co?)
      msg = string.gsub(msg, "YOUR_CLASS2", player_class.D1);          -- Dopełniacz (kogo, czego?)
      msg = string.gsub(msg, "YOUR_CLASS3", player_class.C1);          -- Celownik (komu, czemu?)
      msg = string.gsub(msg, "YOUR_CLASS4", player_class.B1);          -- Biernik (kogo, co?)
      msg = string.gsub(msg, "YOUR_CLASS5", player_class.N1);          -- Narzędnik (z kim, z czym?)
      msg = string.gsub(msg, "YOUR_CLASS6", player_class.K1);          -- Miejscownik (o kim, o czym?)
      msg = string.gsub(msg, "YOUR_CLASS7", player_class.W1);          -- Wołacz (o!)
      msg = string.gsub(msg, "YOUR_RACE1", player_race.M1);            -- Mianownik (kto, co?)
      msg = string.gsub(msg, "YOUR_RACE2", player_race.D1);            -- Dopełniacz (kogo, czego?)
      msg = string.gsub(msg, "YOUR_RACE3", player_race.C1);            -- Celownik (komu, czemu?)
      msg = string.gsub(msg, "YOUR_RACE4", player_race.B1);            -- Biernik (kogo, co?)
      msg = string.gsub(msg, "YOUR_RACE5", player_race.N1);            -- Narzędnik (kim, czym?)
      msg = string.gsub(msg, "YOUR_RACE6", player_race.K1);            -- Miejscownik (o kim, o czym?)
      msg = string.gsub(msg, "YOUR_RACE7", player_race.W1);            -- Wołacz (o!)
      msg = string.gsub(msg, "YOUR_RACE YOUR_CLASS", "YOUR_RACE "..player_class.M1);     -- Mianownik (kto, co?)
      msg = string.gsub(msg, "ym YOUR_RACE", "ym "..player_race.N1);              -- Narzędnik (kim, czym?)
      msg = string.gsub(msg, " jesteś YOUR_RACE", " jesteś "..player_race.N1);    -- Narzędnik (kim, czym?)
      msg = string.gsub(msg, "YOUR_RACE", player_race.W1);                        -- Wołacz - pozostałe wystąpienia
      msg = string.gsub(msg, "ym YOUR_CLASS", "ym "..player_class.N1);            -- Narzędnik (kim, czym?)
      msg = string.gsub(msg, "esteś YOUR_CLASS", "esteś "..player_class.N1);      -- Narzędnik (kim, czym?)
      msg = string.gsub(msg, " z Ciebie YOUR_CLASS", " z Ciebie "..player_class.M1);    -- Mianownik (kto, co?)
      msg = string.gsub(msg, " kolejny YOUR_CLASS do ", " kolejny "..player_class.M1.." do ");   -- Mianownik (kto, co?)
      msg = string.gsub(msg, " taki YOUR_CLASS", " taki "..player_class.M1);      -- Mianownik (kto, co?)
      msg = string.gsub(msg, "ako YOUR_CLASS", "ako "..player_class.M1);          -- Mianownik (kto, co?)
      msg = string.gsub(msg, " co sprowadza YOUR_CLASS", " co sprowadza "..player_class.B1);     -- Biernik (kogo, co?)
      msg = string.gsub(msg, " będę miał YOUR_CLASS", " będę miał "..player_class.B1);  -- Biernik (kogo, co?)
      msg = string.gsub(msg, "ego YOUR_CLASS", "ego "..player_class.B1);                -- Biernik (kogo, co?)
      msg = string.gsub(msg, "YOUR_CLASS taki jak ", player_class.B1.." taki jak ");    -- Biernik (kogo, co?)
      msg = string.gsub(msg, " jak na YOUR_CLASS", " jak na "..player_class.B1);        -- Biernik (kogo, co?)
      msg = string.gsub(msg, "YOUR_CLASS", player_class.W1);                      -- Wołacz - pozostałe wystąpienia
   end

  return msg;
end

