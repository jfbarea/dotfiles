Feature nueva en un repo ya existente.

1. Lee SPEC.md y plan/PLAN.md si existen para entender el contexto.
2. Si te invocan desde /research con un hand-off, lee `plan/research/<slug>.md` (resumen destilado, NO el .html) y úsalo como input principal en lugar de preguntarme la feature desde cero.
3. Si no existe `plan/`, créalo con la estructura mínima (`plan/PLAN.md`, `plan/_state.json` con `milestones: []`, `plan/reviews/`).
4. Si no hay hand-off de research, pregúntame qué feature quiero.
5. Añade un nuevo hito (o varios si es grande) a `plan/PLAN.md` y `plan/_state.json` con slug y criterios de aceptación. Enséñamelo y espera OK.
6. Cuando dé OK, ciclo builder → reviewer hasta que el hito esté DONE.
7. NO toques otros hitos del plan.
