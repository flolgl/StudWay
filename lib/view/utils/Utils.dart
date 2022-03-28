class Utils{

  static String getDiff(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    var diff = to.difference(from);
    if (diff.inDays > 0) {
      return '${diff.inDays} jours';
    } else if (diff.inHours > 0) {
      return '${diff.inHours} heures';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes} minutes';
    } else{
      return "Moins d'1 minute";
    }
  }
}