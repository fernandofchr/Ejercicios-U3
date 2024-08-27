from machine import Pin, SoftI2C
import ssd1306
import utime
from max30102 import MAX30102

# Configura el I2C y la pantalla OLED
i2c = SoftI2C(scl=Pin(22), sda=Pin(21))
oled_width = 128
oled_height = 64
oled = ssd1306.SSD1306_I2C(oled_width, oled_height, i2c)

# Configura el sensor MAX30102
sensor = MAX30102(i2c=i2c)
sensor.setup_sensor()

# Función para dibujar la gráfica de barras
def draw_graph(oled, values):
    oled.fill(0)  # Limpia la pantalla
    
    if len(values) == 0:  # Verifica si la lista está vacía
        return  # Sal de la función si no hay datos para graficar

    max_value = max(values)  # Encuentra el valor máximo
    
    if max_value == 0:  # Verifica si el valor máximo es cero
        scale = 1  # Usa un valor de escala predeterminado para evitar división por cero
    else:
        scale = oled_height / max_value  # Escala los valores para que se ajusten a la pantalla

    bar_width = oled_width // len(values)  # Calcula el ancho de cada barra

    # Dibuja las barras
    for i, value in enumerate(values):
        x = i * bar_width
        bar_height = int(value * scale)
        y = oled_height - bar_height
        oled.rect(x, y, bar_width, bar_height, 1)  # Dibuja el rectángulo (barra)

    oled.show()

# Lista para almacenar los últimos valores del sensor
ir_values = []

# Bucle principal
while True:
    # Leer datos del sensor
    sensor.check()
    if sensor.available():
        red_data = sensor.pop_red_from_storage()
        ir_data = sensor.pop_ir_from_storage()
        
        # Agrega los datos IR a la lista de valores
        ir_values.append(ir_data)
        if len(ir_values) > oled_width // 2:  # Limita el número de valores para que quepan en la pantalla
            ir_values.pop(0)
        
        # Actualizar la pantalla OLED con la gráfica de barras
        draw_graph(oled, ir_values)
        
        # Limpiar y actualizar la pantalla con los valores actuales
       

    # Esperar antes de la próxima lectura
    utime.sleep_ms(100)  # Ajusta el tiempo según la frecuencia deseada
