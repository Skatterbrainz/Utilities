Add-Type -AssemblyName System.speech
$speak = New-Object System.Speech.Synthesis.SpeechSynthesizer

$speak.GetInstalledVoices().voiceInfo

$speak.SelectVoice('Microsoft David Desktop')
#$speak.SelectVoice('Microsoft Zira Desktop')

$readThis = "Can you hear me now?"

$speak.speak($readThis)

$speak.Dispose()
