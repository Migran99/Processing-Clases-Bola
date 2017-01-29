Table score_table;

void setup() {
  if (!fileExists(sketchPath("scores.csv"))) {
    score_table = new Table();
    score_table.addColumn("name");
    score_table.addColumn("points");
    score_table.addRow();
    score_table.addRow();
    score_table.addRow();

    score_table.setString(0, "name", "Player1" );
    score_table.setString(1, "name", "Player2" );
    score_table.setString(2, "name", "Player3" );
    saveTable(score_table, "scores.csv");
    println("File Created");
  } 
  else {
    println("File found");
    println("Loading File");
    score_table = loadTable("scores.csv");
    println(score_table.getRowCount() + " total rows in table");
  }
}

boolean fileExists(String name) {
  File file=new File(name);
  println(file.getName());
  boolean exists = file.exists();
  if (exists) {
    println("true");
    return true;
  } else {
    println("false");
    return false;
  }
} 
