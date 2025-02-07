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
	
	_length: number,
	_timeLeft: number,
	_isRunning: boolean,
	
	_endedCallback: () -> (),
	
	_thread: thread
	
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
		_length = length,
		_timeLeft = 0,
		_endedCallback = endedCallback or function() end,
		_isRunning = false,
		
		_thread = nil
	}, class :: class) :: object
end

--[[
	Resumes a timer when it's initialized or 
	creates a new one when a timer doesn't exist yet
]]
function class:start()
	if self._thread and coroutine.status(self._thread) == "suspended" then
		self._isRunning = true
		coroutine.resume(self._thread)
		return
	end
	
	self._timeLeft = self._length
	self._isRunning = true
	
	self._thread = task.spawn(function()
		while self._timeLeft > 0 do
			if not self._isRunning then
				coroutine.yield(self._thread)
				continue
			end
			
			self._timeLeft -= task.wait()

			if self._timeLeft <= 0 then
				self._endedCallback()
				
				self._isRunning = false
				self._timeLeft = 0
				
				break
			end
		end
	end)
end

--[[
	Pauses the timer for later resumption
]]
function class:pause()
	self._isRunning = false
end

--[[
	@param  stop: boolean              --Should the timer be paused after resetting
	
	Resets the timer's time left to timer's default length
]]
function class:reset(pause)
	if pause then
		self._isRunning = false
	end
	
	self._timeLeft = self._length
end

--[[
	Cleans the memory from the timer
]]
function class:destroy()
	if self._thread then
		coroutine.close(self._thread)
		self._thread = nil
	end
	
	table.clear(self)
end
--[[
	@return boolean                   --Returns if the timer is currently running       
]]
function class:getIsRunning()
	return self._isRunning
end

--[[
	@return number                   --Returns time left for the callback to be executed
]]
function class:getTimeLeft()
	return self._timeLeft
end

return class
