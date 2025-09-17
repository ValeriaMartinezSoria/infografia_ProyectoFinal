# Overcooking

**Overcooking** es un juego inspirado en *Overcooked*, desarrollado en **Godot **.  
El jugador asume el rol de un chef en una cocina interactiva, donde debe **recoger ingredientes, colocarlos en platos, cocinarlos y servirlos a tiempo**.  

Este proyecto fue creado como parte de un trabajo académico, integrando conceptos de **arquitectura, diseño de software y programación orientada a objetos**.

---

##  Características principales
-  Sistema de **recogida y colocación de ingredientes** (`pickup_object`, `_drop_object`, `add_ingredient`).
-  Cocción interactiva en hornillas, con sonidos (`cook_sound`) y efectos visuales.
-  Preparación y **servido de platos completos** con un solo botón.
-  Estilo visual simple pero funcional, centrado en la jugabilidad.
-  Efectos de sonido para mejorar la experiencia inmersiva.
- (Código final en main)
---

##  Controles
- **W / A / S / D** → Mover al jugador.
- **g (Grab)** → Recoger o soltar ingrediente/plato.
- **c (Cook)** → Encender hornilla / cocinar ingrediente.
- **s (Serve)** → Servir el plato preparado.
- **c (Cut)** → Cortar ingredientes.

---

##  Arquitectura y diseño
- Proyecto desarrollado en **Godot 4**.
- Uso del **patrón de diseño Facade** para simplificar la interacción entre objetos del juego.
- Organización en escenas y scripts (`Player.gd`, `Plato.gd`, `MesonPrep.gd`, `Hornilla.gd`).
- Métodos principales:
  - `pickup_object` → Permite al jugador recoger platos o ingredientes desde un área cercana.
  - `_drop_object` → Suelta un objeto en el mesón o en el suelo, gestionando posiciones.
  - `add_ingredient` → Agrega un ingrediente a un plato existente, manteniendo jerarquía visual.
- Jerarquía clara en escenas: **Player**, **Plato**, **Ingredientes**, **Hornilla**, **Mesón**.

---
##  Objetivos del proyecto
- Desarrollar un **juego funcional y divertido**, inspirado en *Overcooked*.
- Aplicar conceptos de **arquitectura y patrones de diseño** en Godot.
- Implementar un sistema de **interacción fluida entre objetos**.
- Explorar la integración de **sonido, animaciones y lógica de juego** en un entorno real.

---

## Alcance a futuro
- Implementar **multijugador cooperativo local/online**.
- Añadir **más recetas y niveles de dificultad**.
- Sistema de **puntuación y tiempos límite** para mayor reto.
- **Mejores animaciones y gráficos** para acercarse más a Overcooked.
- Creación de un **menú de inicio y configuración**.

---

##  Autores
- Diego Gomez
- Valeria Martínez
- Sebastian Nuñez

---

## Licencia
Este proyecto es de uso académico y educativo.  
No tiene fines comerciales y está inspirado en *Overcooked*.

