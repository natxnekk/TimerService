--[[
	Service made by @natxnek [discord: @natixo]
	
	Memory usage:
		- Variable: ~600 Bytes
		- Worker:   ~600 Bytes
	
	Feel free to fork the service and update it for your purposes
	
	License: Creative Commons Attribution-NonCommercial 4.0 International (CC BY-NC 4.0)
	Copyright (c) 2025 @natxnek
	
	For the full license, visit: https://creativecommons.org/licenses/by-nc/4.0/
]]

local class = {} :: class
class.__index = class

--Types
type class = {
	__index: class,
	new: ( length: number, endedCallback: () -> () ) -> object,

	start: (self: object) -> (),
	pause: (self: object) -> (),
	reset: (self: object, pause: boolean) -> (),
	destroy: (self: object) -> (),
	getIsRunning: (self: object) -> boolean,
	getTimeLeft: (self: object) -> number,
}

type object = typeof(setmetatable({} :: {
	
	length: number,
	timeLeft: number,
	isRunning: boolean,
	
	endedCallback: () -> (),
	
	thread: thread
	
}, {} :: class))

--Functions

--[[
	@param  length: number              --The length of the timer
	@param  endedCallback: () -> ()     --The function that is executed when a timer is finished
	@return object                      --Returns a new Timer object

	Creates a new Timer object (metatable)
]]
function class.new(length, endedCallback)
	return setmetatable({
		['length'] = length,
		['timeLeft'] = 0,
		['endedCallback'] = endedCallback,
		['isRunning'] = false,
		
		['thread'] = nil
	}, class :: class) :: object
end

--[[
	Resumes a timer when it's initialized or 
	creates a new one when a timer doesn't exist yet
]]
function class:start()
	if self.thread then
		self.isRunning = true
		coroutine.resume(self.thread)
		return
	end
	
	self.timeLeft = self.length
	self.isRunning = true
	
	self.thread = task.spawn(function()
		while self.timeLeft > 0 do
			if not self.isRunning then
				coroutine.yield(self.thread)
				continue
			end
			
			self.timeLeft -= task.wait()

			if self.timeLeft <= 0 then
				if self.endedCallback then self.endedCallback() end
				self.isRunning = false
				self.timeLeft = 0
				
				break
			end
		end
	end)
	
	coroutine.resume(self.thread)
end

--[[
	Pauses the timer for later resumption
]]
function class:pause()
	self.isRunning = false
end

--[[
	@param  stop: boolean              --Should the timer be paused after resetting
	
	Resets the timer's time left to timer's default length
]]
function class:reset(pause)
	if pause then
		self.isRunning = false
	end
	
	self.timeLeft = self.length
end

--[[
	Cleans the memory from the timer
]]
function class:destroy()
	if self.thread then
		coroutine.close(self.thread)
		self.thread = nil
	end
	
	table.clear(self)
end
--[[
	@return boolean                   --Returns if the timer is currently running       
]]
function class:getIsRunning()
	return self.isRunning
end

--[[
	@return number                   --Returns time left for the callback to be executed
]]
function class:getTimeLeft()
	return self.timeLeft
end

return class
