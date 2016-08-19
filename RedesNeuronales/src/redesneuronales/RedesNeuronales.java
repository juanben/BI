package redesneuronales;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import weka.classifiers.Evaluation;
import weka.classifiers.functions.MultilayerPerceptron;
import weka.core.Instances;
import weka.core.converters.ConverterUtils;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import weka.classifiers.bayes.NaiveBayes;
import weka.classifiers.trees.J48;


public class RedesNeuronales {

    public void perceptron_multicapa(String dir, int x) {
        try {

            //Llamar funcion para generar el nuevo archivo Arff
            generarArff();
            // Llamar al archivo .arff
            ConverterUtils.DataSource converU = new ConverterUtils.DataSource("./arff/entrenar.arff");
            Instances instancias = converU.getDataSet();
            //Para evitar desborde de datos
            instancias.setClassIndex(instancias.numAttributes() - 1);
            //Construir la red  MUlticapa
            NaiveBayes red = new  NaiveBayes();
            red.buildClassifier(instancias);
            //evaluar modelo
            Evaluation ev = new Evaluation(instancias);

            ev.evaluateModel(red, instancias);
            System.out.println("Naive Bayes");
            //impresion de instancias y Matriz de confución
           // System.out.println(instancias);
            System.out.println(ev.toSummaryString("Resultado NaiveBayes ", true));
            System.out.println(ev.toMatrixString("Matriz de confucion"));
            String salida="";
            ArrayList<String> arreglo = new ArrayList();
            
            //Usando J48 
            System.out.println("Algoritmo con J48");
            J48 red1 = new  J48();
            red1.buildClassifier(instancias);
            //evaluar modelo
            Evaluation ev1 = new Evaluation(instancias);
            ev1.evaluateModel(red1, instancias);
            //impresion de instancias y Matriz de confución
           // System.out.println(instancias);
            System.out.println(ev1.toSummaryString("Algoritmo J48 ",true));
            System.out.println(ev1.toMatrixString("Matriz de confucion"));
          
//salida deseada
            if (x == 1) 
            {
                System.out.println("Salida Deseada");
                ConverterUtils.DataSource converU1 = new ConverterUtils.DataSource(dir);
                Instances datosRev = converU1.getDataSet();
                datosRev.setClassIndex(instancias.numAttributes()-1);
                Instances inst2 = new Instances(datosRev);
                ev.evaluateModel(red, inst2);
                for (int i = 0; i < ev.evaluateModel(red, inst2).length; i++) 
                {
                    if(ev.evaluateModel(red, inst2)[i]+1==1)
                    {
                        //System.out.println("No tiene Hepatitis");
                        salida="neutro";
                        arreglo.add(salida);
                        
                        
                    }else
                    {
                    if(ev.evaluateModel(red, inst2)[i]+1==2)
                    {
                            //System.out.println("Tiene Hepatitis");
                            salida="positivo";
                            arreglo.add(salida);
                            
                    }
                    else
                    {
                         //System.out.println("Tiene Hepatitis");
                            salida="negativo";
                            arreglo.add(salida);
                    }
                        
                    }
                    
                }
                modificarArchivo(arreglo);
               // System.out.println(inst2);
            }
        } catch (Exception ex) {
            Logger.getLogger(RedesNeuronales.class.getName()).log(Level.SEVERE, null, ex);
        }

    }
    public void modificarArchivo(ArrayList salida) throws IOException
    {
       File archivo = new File("../RedesNeuronales/src/arff/salida.arff");
       File archivo2 = new File("../RedesNeuronales/src/arff/prueba.arff");
       BufferedWriter bw;
       String datos="";
       int i=0;
        
        if (archivo.exists()) 
        {
           bw = new BufferedWriter(new FileWriter(archivo, true));         
           BufferedReader Flee= new BufferedReader(new FileReader(archivo2));
           String Slinea;
           System.out.println("**********Leyendo Fichero***********");
           
           /*Lee el fichero linea a linea hasta llegar a la ultima*/
           while((Slinea=Flee.readLine())!=null) 
           {
             Pattern pat = Pattern.compile(".+,\\? *");
             Matcher mat = pat.matcher(Slinea);
            if(mat.matches())
            {
             /*Imprime la linea leida*/    
               datos+= Slinea.replace("? ", (CharSequence) salida.get(i))+"\n";
               i++;
            }       
            
           }
           bw.write(datos+"\r\n");
           System.out.println("*********Fin Leer Fichero**********");
           /*Cierra el flujo*/
           Flee.close();
            
        } 
        else
        {
            bw = new BufferedWriter(new FileWriter(archivo));
            bw.write(salida+"\r\n");
        }
           bw.close();
    }
    public void generarArff() throws IOException
    {
        File archivo = new File("../RedesNeuronales/src/arff/salida.arff");
        BufferedWriter bw;
        if (archivo.exists()) 
        {
            bw = new BufferedWriter(new FileWriter(archivo));
            bw.write("@relation entrenar\r\n" +
            "@attribute noun {yes,no}\r\n" +
            "@attribute prepositional {yes,no}\r\n" +
            "@attribute CoordinatingConjunction {yes,no}\r\n" +
            "@attribute SubordinatingConjunction {yes,no}\r\n" +
            "@attribute ConjuntiveAdverbs {yes,no}\r\n" +
            "@attribute verbPositive real\r\n" +
            "@attribute verbNegative real\r\n" +
            "@attribute adjetivePositive real\r\n" +
            "@attribute adjetiveNegative real\r\n" +
            "@attribute numPalabras real\r\n" +
            "@attribute puntiacion {yes,no}\r\n" +
            "@attribute resul {neutro,positivo,negativo}\r\n"+
            "@data\r\n");
        }
        else
        {
            bw = new BufferedWriter(new FileWriter(archivo));
            bw.write("@relation entrenar\r\n" +
            "@attribute noun {yes,no}\r\n" +
            "@attribute prepositional {yes,no}\r\n" +
            "@attribute CoordinatingConjunction {yes,no}\r\n" +
            "@attribute SubordinatingConjunction {yes,no}\r\n" +
            "@attribute ConjuntiveAdverbs {yes,no}\r\n" +
            "@attribute verbPositive real\r\n" +
            "@attribute verbNegative real\r\n" +
            "@attribute adjetivePositive real\r\n" +
            "@attribute adjetiveNegative real\r\n" +
            "@attribute numPalabras real\r\n" +
            "@attribute puntiacion {yes,no}\r\n" +
            "@attribute resul {neutro,positivo,negativo}\r\n"+
            "@data\r\n");
            
        }
           bw.close();      
    }
    

}

   
    

