-- CURVES
hl.config({ animations = { enabled = true } })

hl.curve("Cubic", { type = "bezier", points = { { 0.22, 0.61 }, { 0.36, 1 } } })
hl.curve("Quart", { type = "bezier", points = { { 0.17, 0.84 }, { 0.44, 1 } } })
hl.curve("Quint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("Expo", { type = "bezier", points = { { 0.19, 1 }, { 0.22, 1 } } })

-- WINDOWS
hl.animation({ leaf = "windows", enabled = true, speed = 5, bezier = "Expo", style = "popin 87%" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 5, bezier = "Quart", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 4, bezier = "Quart", style = "popin 87%" })

-- BORDER
hl.animation({ leaf = "border", enabled = true, speed = 8, bezier = "default" })

-- FADE
hl.animation({ leaf = "fade", enabled = true, speed = 5, bezier = "Quint" })
hl.animation({ leaf = "fadeDim", enabled = true, speed = 5, bezier = "Quint" })

-- WORKSPACE
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "Expo" })

-- SPECIAL WORKSPACE
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 5, bezier = "Quint", style = "slidevert" })