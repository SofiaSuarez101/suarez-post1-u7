# Post-contenido Unidad 7 — Manejo de Pantalla y Teclado en NASM sobre DOSBox

**Asignatura:** Arquitectura de Computadores

Este repositorio reúne las dos partes del laboratorio: la Parte 1 (INT 21h e INT 10h) y la Parte 2 (INT 16h y acceso directo a B800h). Todos los programas se ensamblan con NASM y se ejecutan en DOSBox.

## Estructura del repositorio

```
suarez-post1-u7/
├── README.md
├── parte1/  post1.asm  post1b.asm  post1c.asm  post1d.asm  (+ .com)
├── parte2/  post2a.asm post2b.asm  post2c.asm  post2d.asm  post2e.asm (+ .com)
└── capturas/ (capturas de la ejecucion
)
```

Compilación y ejecución (ejemplo): `nasm -f bin post1.asm -o post1.com` y luego `post1.com`.

---

## Decisión técnica 1 — ¿INT 21h o INT 10h para esta salida de texto?

El uso de INT 21h/AH=09h es la opción apropiada cuando se imprime texto plano sin necesidad de color ni posicionamiento fino, como el encabezado de `post1.asm`: una sola llamada con DS:DX imprime toda la cadena y el sistema avanza el cursor solo. INT 21h/AH=09h no admite un atributo de color, por lo que INT 10h/AH=09h resulta obligatorio en `post1b.asm`, `post1c.asm` y `post1d.asm`, donde se exige amarillo sobre azul, verde brillante o verde de fondo en celdas exactas. Complicar con INT 10h una salida que no requiere color sería un gasto innecesario: `post1c.asm` necesita un bucle que posiciona el cursor con AH=02h y escribe con AH=09h por cada carácter, mientras que `post1.asm` resuelve lo mismo con tres llamadas. Además, el Paso 4 depende de que el modo de video soporte atributos de color únicamente en la ruta INT 10h; INT 21h nunca maneja atributos y funciona igual sin importar el modo activo.

## Decisión técnica 2 — Verificar el modo de video y releer la celda en lugar de asumir

Si el modo de video activo no fuera 03h al ejecutar `post1b.asm` y `post1c.asm`, los atributos de color podrían interpretarse de forma distinta (por ejemplo en un modo gráfico o monocromo) o la pantalla podría corromperse, porque esos programas suponen texto de 80×25 con 16 colores. INT 10h/AH=0Fh es la forma correcta de comprobarlo, ya que devuelve el modo real en AL, las columnas en AH y la página activa en BH, en lugar de dejar la suposición fija en el código. Releer la celda con AH=08h aporta otra ventaja: confirma que carácter y atributo almacenados coinciden con lo escrito y detecta si algo modificó la celda, lo que en un editor de pantalla evitaría un error silencioso de consistencia. AH=08h es portable entre modos sin conocer la aritmética segmento:offset, mientras que el acceso directo a B800h de la Parte 2 es más rápido pero exige conocer de antemano el modo y el formato de memoria.
