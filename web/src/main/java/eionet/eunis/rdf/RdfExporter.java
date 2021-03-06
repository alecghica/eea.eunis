/**
 *
 */
package eionet.eunis.rdf;

import java.io.File;
import java.io.FileOutputStream;
import java.sql.Connection;
import java.util.Properties;
import java.util.ResourceBundle;

import eionet.eunis.util.sql.ConnectionUtil;
import eionet.rdfexport.RDFExportService;
import eionet.rdfexport.RDFExportServiceImpl;

/**
 * @author Risto Alt
 *
 */
public class RdfExporter {

    /**
     * main method.
     *
     * @param args - Command line arguments
     */
    public static void main(String... args) {
        if (args.length == 0) {
            System.out.println("Missing argument what to import!");
            System.out.println("Usage: rdfExporter [table] [identifier]");
        } else {
            String table = null;
            String identifier = null;

            int i = 0;
            for (String arg : args) {
                if (i == 0) {
                    table = arg;
                } else if (i == 1) {
                    identifier = arg;
                }
                i++;
            }

            try {
                ResourceBundle props = ResourceBundle.getBundle("rdfexport");
                String dir = props.getString("files.dest.dir");

                File file = new File(dir, table + ".rdf");
                FileOutputStream fos = new FileOutputStream(file);

                Connection con = ConnectionUtil.getSimpleConnection();
                Properties properties = new Properties();
                properties.load(RdfExporter.class.getClassLoader().getResourceAsStream("rdfexport.properties"));
                RDFExportService rdfExportService = new RDFExportServiceImpl(fos, con, properties);
                rdfExportService.exportTable(table, identifier);

                con.close();
                fos.close();

                System.out.println("Successfully exported to: " + dir + "/" + table + ".rdf");
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
