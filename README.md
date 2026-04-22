# Timer Service

A lightweight and efficient timer service for **Roblox Studio**, made by **[@natxnek](https://github.com/natxnekk)**.  
This module allows you to create, pause, reset, and destroy timers easily.

<i>This module is designed for the old typesolver, the source code is original and only this readme file was generated using AI</i>

## 🚀 Features
- 📏 **Small memory footprint** (~600 Bytes per instance)
- ⏳ **Start, pause, and reset** timers
- 🧹 **Automatic cleanup** to prevent memory leaks
- 🔄 **Custom callback execution** when the timer ends
- ✅ **Simple API** for easy integration

---

## 📜 License  
This project is licensed under the **MIT License**.  
You are **free to use, modify, share, and include this module in commercial projects**, including monetized Roblox games.  
✅ **Attribution is required** – please keep the original license text and credit the author.  

Read the full license [here](./LICENSE).

---

## 📦 Installation
1. Download the module script from this repository.
2. Insert it into **Roblox Studio** as a ModuleScript.
3. Require it in your script to start using it.

---

## 🔧 Usage

### **Creating a Timer**
```lua
local Timer = require(game.ReplicatedStorage.TimerService) -- Adjust path as needed

-- Create a timer that lasts 10 seconds and prints "Timer ended!" when done
local myTimer = Timer.new(10, function()
    print("Timer ended!")
end)
```

### **Starting the Timer**
```lua
myTimer:start()
```

### **Pausing the Timer**
```lua
myTimer:pause()
```

### **Resetting the Timer**
```lua
myTimer:reset(true) -- Pass 'true' to pause after reset
```

### **Checking Timer State**
```lua
print("Is running:", myTimer:getIsRunning()) -- true/false
print("Time left:", myTimer:getTimeLeft())   -- Remaining seconds
```

### **Destroying the Timer**
```lua
myTimer:destroy() -- Cleans up memory
```

---

## 📌 Notes
- The timer **runs in a coroutine** to prevent blocking execution.
- The `endedCallback` function is executed when the timer reaches 0.
- Destroy unused timers to **free memory**.

---

## 👤 Author
- **[@natxnek](https://github.com/natxnek)**  
- Discord: **@natxnek**

---

## ⭐ Contributing
Feel free to **fork this repository** and improve the service!  
If you find any issues or have feature suggestions, open a **GitHub Issue**.

---

## ❤️ Support
If you like this project, give it a ⭐ on GitHub!
