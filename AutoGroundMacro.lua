-- Grettings message
print("Check out AutoGroundMacro with \124cnFRIENDS_WOW_NAME_COLOR:/agm help\124r")

-- Getting current Locale
local locale = GetLocale()

-- Defining Slash commands
SLASH_AUTOGROUNDMACRO1 = "/agm"
SLASH_AUTOGROUNDMACRO2 = "/autogroundmacro"

-- Slash commands function
SlashCmdList.AUTOGROUNDMACRO = function(msg, editBox)
    if msg == "clear" then
        ClearAllAGMMacros()
    elseif msg == "reset" then
        ClearAllAGMMacros()
        SearchTargetLocationSpells()
    elseif msg == "help" then
        local helpText1 = "\124cnFRIENDS_WOW_NAME_COLOR:/agm help\124r List of commands."
        local helpText2 = "\124cnFRIENDS_WOW_NAME_COLOR:/agm clear\124r Deletes all AGM macros."
        local helpText3 = "\124cnFRIENDS_WOW_NAME_COLOR:/agm reset\124r Deletes and creates all AGM macros."
        print(helpText1)
        print(helpText2)
        print(helpText3)
    elseif msg == "run" or msg == "" then
        SearchTargetLocationSpells()
    end
end

local function OnEvent(self, event, ...)
    SearchTargetLocationSpells()
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_TALENT_UPDATE")
f:RegisterEvent("SPELLS_CHANGED")
f:SetScript("OnEvent", OnEvent)

-- Get current spells taht have "target location" in the description
function SearchTargetLocationSpells()
    for i = 1, C_SpellBook.GetNumSpellBookSkillLines() do
        local skillLineInfo = C_SpellBook.GetSpellBookSkillLineInfo(i)
        local offset, numSlots = skillLineInfo.itemIndexOffset, skillLineInfo.numSpellBookItems
        for spellBookItemSlotIndex = offset + 1, offset + numSlots do
            -- Search Spells
            local spellDescription =
                C_SpellBook.GetSpellBookItemDescription(spellBookItemSlotIndex, Enum.SpellBookSpellBank.Player)
            local spellBookItemInfo =
                C_SpellBook.GetSpellBookItemInfo(spellBookItemSlotIndex, Enum.SpellBookSpellBank.Player)
            local spellName

            -- Getting spellname
            if
                spellBookItemInfo.itemType == Enum.SpellBookItemType.Spell or
                    spellBookItemInfo.itemType == Enum.SpellBookItemType.FutureSpell
             then
                spellName = C_Spell.GetSpellName(spellBookItemInfo.actionID)
            end

            -- Create Macro
            if locale == "ptBR" then
                if string.find(spellDescription, " local selecionado") ~= nil then
                    CreatePersonalMacro(spellName)
                elseif string.find(spellDescription, " dentro da área") ~= nil then
                    CreatePersonalMacro(spellName)
                elseif string.find(spellDescription, " na área") ~= nil then
                    CreatePersonalMacro(spellName)
                elseif string.find(spellDescription, " em um raio de") ~= nil then
                    CreatePersonalMacro(spellName)
                end
            else
                if string.find(spellDescription, "target location") ~= nil then -- Heroic Leap - Warrior
                    CreatePersonalMacro(spellName)
                elseif string.find(spellDescription, " targeted location") ~= nil then -- Farsight - Shaman
                    CreatePersonalMacro(spellName)
                elseif string.find(spellDescription, " within the area") ~= nil then -- Flamestrike - Mage
                    CreatePersonalMacro(spellName)
                elseif string.find(spellDescription, " in the area") ~= nil then -- Volley - Hunter
                    CreatePersonalMacro(spellName)
                elseif string.find(spellDescription, "d radius") ~= nil then -- Mass Dispel - Priest
                    CreatePersonalMacro(spellName)
                elseif string.find(spellDescription, "Stuns all enemies within 8 yds for 3 sec.") ~= nil then -- Shadowfury - Warlock
                    CreatePersonalMacro(spellName)
                end
            end
        end
    end
end

function CreatePersonalMacro(spellName)
    local macroName = "AGM " .. spellName
    if GetMacroIndexByName(macroName) == 0 then
        CreateMacro(macroName, "INV_MISC_QUESTIONMARK", "#showtooltip\n/cast [@cursor] " .. spellName, 1)
        print("New personal macro: " .. macroName)
    end
end

function ClearAllAGMMacros()
    for i = 120 + select(2, GetNumMacros()), 121, -1 do
        local macroName = select(1, GetMacroInfo(i))
        if string.find(macroName, "AGM ") ~= nil then
            DeleteMacro(i)
        end
    end
end
