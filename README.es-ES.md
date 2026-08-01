

# Script no oficial de Octavi IFR-1 para X-Plane/FlyWithLua
Permite el uso del IFR-1 en plataformas no compatibles. Probado en macOS.

## Acerca de
No presté suficiente atención cuando lo compré y, cuando llegó tres días antes de Navidad, me decepcionó descubrir que los complementos solo son compatibles con Windows. Había alguna mención de un script de Lua disponible bajo petición para admitir Mac y Linux, pero por supuesto el plazo era demasiado corto para conseguir una copia con la que experimentar durante las vacaciones. Además, es extraño que no lo pongan a disposición para descargar, incluso con un aviso como "esto carece totalmente de soporte, no nos escriban si tienen problemas".

Así que me quedé con un proyecto extra para las vacaciones y me puse a trabajar para averiguar cómo escribir en Lua, cómo leer y escribir datos USB HID y cómo funciona el IFR-1 por dentro.

## Instalación
1. Instala [FlyWithLua](https://forums.x-plane.org/index.php?/files/file/38445-flywithlua-ng-next-generation-edition-for-x-plane-11-win-lin-mac/)
2. Descarga y copia `octavi-ifr-1.lua` en el directorio `Scripts` de FlyWithLua.

## Uso
El script intenta abrir el IFR-1 al cargar y verifica periódicamente. Debería conectarse o reconectarse automáticamente si el IFR-1 no está conectado al iniciar o si se desconecta y vuelve a conectar.

En COM1, COM2, NAV1, NAV2 y AP, presionar el botón de la perilla activará el modo cambio. Todos los LEDs se encenderán y parpadearán para indicar el modo cambio. Este modo generalmente hace que la perilla ajuste el valor impreso en azul sobre el botón del modo, pero hay algunas características ocultas adicionales.

La mayoría de las perillas y botones imprimirán un mensaje en la parte superior derecha de la pantalla principal.

### COM1/HDG
Ajusta la frecuencia en espera de COM1. Presiona el botón de intercambio para cambiar a la activa.

En modo cambio, la perilla ajusta la marca de rumbo. Presionar el botón OBS/HDG sincronizará la indicadora de rumbo accionada por vacío con el rumbo de la brújula.

### COM2/BARO
Ajusta la frecuencia en espera de COM2. Presiona el botón de intercambio para cambiar a la activa.

En modo cambio, la perilla ajusta la configuración del altímetro del piloto. Presionar el botón VNAV/ALT sincronizará el altímetro con la configuración actual de nivel del mar en la posición de la aeronave (que no necesariamente es el valor actual del aeropuerto más cercano).

### NAV1/CRS1
Ajusta la frecuencia en espera de NAV1. Presiona el botón de intercambio para cambiar a la activa.

En modo cambio, ajusta la OBS de NAV1.

### NAV2/CRS2
Ajusta la frecuencia en espera de NAV2. Presiona el botón de intercambio para cambiar a la activa.

En modo cambio, ajusta la OBS de NAV2 (NOTA: esto está configurado para ajustar la OBS de NAV2 del _copiloto_, porque el instrumento en el C172 predeterminado de Steam de X-Plane aparentemente está configurado para usar el dataref del copiloto).

### FMS1, FMS2
Estos son los modos principales que están configurados para ser específicos para aeronaves con navegadores GNS430/530, ya que utilizan comandos de X-Plane específicos para el 430. En estos modos, los botones inferiores y laterales derechos, así como las perillas (incluido hacer clic en la perilla para el cursor), operan los navegadores. Desarrollé y probé el script con el C172 predeterminado de Steam, que es lo que uso actualmente para practicar con instrumentos.

### AP
Los LEDs indican el estado del AP y los botones inferiores seleccionan el modo de AP. La perilla pequeña ajusta la preselección de altitud y la perilla grande ajusta la velocidad vertical objetivo.

La VS hasta la ALT preseleccionada se puede activar presionando ALT mientras se mantiene presionado VS (presiona y mantén VS, luego presiona ALT mientras sigues manteniendo VS, luego suelta ambos).

En modo cambio, presionar APR/FPL activará el modo backcourse.

### XPDR/MODE
Ajusta el código del transpondedor. La perilla grande ajusta los dos primeros dígitos y la perilla pequeña los dos últimos.

Presionar el botón de la perilla en modo XPDR hace que el transpondedor ciclé por los modos OFF, STBY, ON y ALT.
Presionar AP/CDI activa IDENT en el transpondedor y el LED se ilumina cuando transmite IDENT.

## Soporte
Ninguno.
