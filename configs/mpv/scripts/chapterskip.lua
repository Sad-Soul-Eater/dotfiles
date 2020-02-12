-- chapterskip.lua
--
-- Ain't Nobody Got Time for That
--
-- This script skips chapters based on their title.

local categories = {
    prologue = "^Prologue/^Intro",
    opening = "^OP/ OP$/^Opening",
    ending = "^ED/ ED$/^Ending",
    preview = "Preview$"
}

local options = {
    enabled = true,
    skip_once = true,
    categories = "",
    skip = ""
}

mp.options = require "mp.options"

function matches(text)
    for category in string.gmatch(options.skip, " *([^;]*[^; ]) *") do
        if categories[category:lower()] then
            for pattern in string.gmatch(categories[category:lower()], "([^/]+)") do
                if string.match(text, pattern) then
                    return true
                end
            end
        end
    end
end

local skipped = {}

function chapterskip(_, current)
    mp.options.read_options(options, "chapterskip")
    if not options.enabled then return end
    for category in string.gmatch(options.categories, "([^;]+)") do
        name, patterns = string.match(category, " *([^+>]*[^+> ]) *[+>](.*)")
        categories[name:lower()] = patterns
    end
    local chapters = mp.get_property_native("chapter-list")
    local skip = false
    for i, chapter in ipairs(chapters) do
        if (not options.skip_once or not skipped[i]) and chapter.title and matches(chapter.title) then
            if i == current + 1 or skip == i - 1 then
                if skip then
                    skipped[skip] = true
                end
                skip = i
            end
        elseif skip then
            mp.set_property("time-pos", chapter.time)
            skipped[skip] = true
            return
        end
    end
    if skip then
        if mp.get_property_native("playlist-count") == mp.get_property_native("playlist-pos-1") then
            return mp.set_property("time-pos", mp.get_property_native("duration"))
        end
        mp.commandv("playlist-next")
    end
end

mp.observe_property("chapter", "number", chapterskip)
mp.register_event("file-loaded", function() skipped = {} end)
