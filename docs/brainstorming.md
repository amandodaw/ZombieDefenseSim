 # QUE TIENE YA EL JUEGO?

- UI muy básica
- Un sistema GOAP, en el cual planea una lista de acciones según el estado del mundo: perception ve el estado del mundo->world_state almacena el estado->goal_system elige el goal (aqui esta la logica de elegir acciones)->goap_system crea el plan->goa_execution_system lo ejecuta. Cambiando las variables de world_state, GOAP elige planes para conseguir eel estado deseado
- Un sistema básico de input con el ratón
- Un sistema básico de ciudad, que guarda todos los humanos y edificios que se crean

 ------------------------------

 ## SIGUIENTE PASO

- Terminar de afinar los componentes que hay en WorkplaceComponent y edificioComponent y citycomponent.
- Crear menu de seleccion de entidades
- Crear opcion de asignar trabajos a NPC's
    - Al principio, solo crear un trabajo por workplace. Más tarde, quizás crear acciones genericas "visitar sitio" o similar.
- Crear acción Work -> Ir a un workplacecomponent y hacer progresar su amount_worked. Conlleva goto + work. La acción work debe causar ciertos estados en el mundo.
    1. Que estado del mundo cambia la acción?
        - Aquí tenemos varias opciones
        - Trabajar -> enough_resources = true
