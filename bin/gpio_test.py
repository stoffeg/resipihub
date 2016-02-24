import RPi.GPIO as GPIO
GPIO.setwarnings(False)
GPIO.cleanup()
GPIO.setmode(GPIO.BCM)
GPIO.setup(19, GPIO.OUT)
GPIO.output(19, True)
GPIO.output(19, False)
GPIO.cleanup()  
