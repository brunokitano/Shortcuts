procName := "process.exe" ; Counts how many processes
pidCount := 0
for proc in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Process"){
	if (proc.Name = procName) {
		pidCount++
		pid%pidCount% := proc.ProcessId
	}
}