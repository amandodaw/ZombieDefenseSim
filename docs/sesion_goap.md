# Sesión GOAP - Resumen

## Problema Inicial
El código debía ejecutar wander → go_to → wander en bucle, pero solo lo hacía una vez.

---

## Solución Implementada

### Archivos modificados:

1. **plan_component.gd**
   - Inicializar el array del plan: `var plan : Array[GoapAction] = []`

2. **goap_system.gd**
   - Agregar evaluación automática de goals
   - Lógica para solo resetear world_state cuando no hay goal activo
   - No re-evaluar goals si ya hay uno activo

3. **goap_execution_system.gd**
   - Resetear world_state cuando una acción termina
   - No limpiar goals (GoapSystem lo maneja)

4. **goal_component.gd**
   - Agregar método `evaluate(entity, world)` para goals dinámicos
   - Sistema preparado para agregar condiciones personalizadas

5. **wander_action.gd**
   - Establecer goal `move_to_target = true` después de setear target
   - Limpiar goal `wander = false` para evitar duplicación

6. **go_to_action.gd**
   - Resetear `has_target = false` y `at_target = false` al llegar al destino

7. **world_state_component.gd**
   - Agregar keys: `at_target`, `wander`

---

## Sistema GOAP Completo

### Flujo actual:
```
Frame 1: evaluate() → wander=true → plan [WanderAction] 
         → WanderAction establece target + move_to_target=true + wander=false
Frame 2: plan [GoToAction] → GoToAction mueve al entity
Frame 3: Llega al destino → reset world_state
Frame 4: evaluate() → wander=true → (repetir)
```

### Para agregar nueva acción:

1. **Crear** `scripts/components/[nombre]_action.gd`:
   - Definir `preconditions` (qué necesita la acción)
   - Definir `effects` (qué logra la acción)
   - Implementar `start()` y opcionalmente `update()`

2. **Registrar** en `action_component.gd`

3. **Agregar goals** en `goal_component.gd`

4. **Agregar condición** en `goal_component.evaluate()`

---

## Notas
- El sistema usa planificación encadenada: una acción puede establecer un nuevo goal para que el planner busque la siguiente acción
- Los goals se evalúan automáticamente cuando no hay ningún goal activo
- El planner GOAP encuentra la secuencia óptima de acciones
