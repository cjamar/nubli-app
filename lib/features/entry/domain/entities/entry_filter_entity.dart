enum EntryFilterEntity {
  all('Todos'),
  notes('Notas'),
  lists('Listas');

  final String label;
  const EntryFilterEntity(this.label);
}
