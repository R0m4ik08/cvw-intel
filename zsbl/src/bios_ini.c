#include <stdint.h>

#include "system.h"
#include "bios_ini.h"

#include "gpiolib.h"

int _bios_ini_c(){

    uint8_t gpio_width = 4 + 18;

    for(int i =0; i < gpio_width; i++){
        pinMode(i, INPUT);
        int val = digitalRead(i);
        
        pinMode(i, OUTPUT);
        digitalWrite(i, val);
    }

    return 0;
}