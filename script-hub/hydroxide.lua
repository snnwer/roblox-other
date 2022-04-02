local function webImport(file)
    return loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/Upbolt/Hydroxide/revision/%s.lua"):format(file)), file .. '.lua')()
end

webImport("init")
webImport("ui/main")