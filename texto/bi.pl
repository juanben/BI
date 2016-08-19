#!/usr/bin/perl

#Estudiante: Juan Sebastian Benavides Cárdenas
#Asignatura: PLN

use Encode;
use utf8;
use warnings;
use strict;
binmode STDOUT, ":utf8";



&main();#Calling main procedure

sub main
{ 
  #
   my $contenido = openFile("texto2.txt");
   my $adjetivosN = openFile(".\\corpus\\adj-negativos.rtf");
   my $adjetivosP=openFile(".\\corpus\\adj-positivos.rtf");
   my $sustantivo=openFile(".\\corpus\\noun.txt");
   my $adConjun = openFile(".\\corpus\\Conjunctive Adverbs.txt");
   my $coorConjun= openFile(".\\corpus\\CoordinatingConjunctions.txt");
   my $preposicion=openFile(".\\corpus\\Preposition.txt");
   my $subConjun = openFile(".\\corpus\\Subordinating Conjunctions.txt");
   my $verbosN = openFile (".\\corpus\\verbsNegative.txt");
   my $verbosP = openFile (".\\corpus\\verbsPositive.txt");
   my $fileName ='limpio.arff';
   my $salida="";
   my $valor;
   my $arff="";
   $arff.='@relation emocion'."\n"."\n";
   $arff.='@attribute noun {yes,no}'."\n";
   $arff.='@attribute prepositional {yes,no}'."\n";
   $arff.='@attribute CoordinatingConjunction {yes,no}'."\n";
   $arff.='@attribute SubordinatingConjunction {yes,no}'."\n";
   $arff.='@attribute ConjuntiveAdverbs {yes,no}'."\n";
   $arff.='@attribute verbPositive real'."\n";
   $arff.='@attribute verbNegative real'."\n";
   $arff.='@attribute adjetivePositive real'."\n";
   $arff.='@attribute adjetiveNegative real'."\n";
   $arff.='@attribute numPalabras real'."\n";
   $arff.='@attribute puntiacion {yes,no}'."\n";   
   $arff.='@attribute resul {neutro,positivo,negativo}'."\n"."\n";
   $arff.='@data'."\n";
   my @oraciones;
   #$contenido =~ s/Some Thoughts[^\[]*//gs;
   $contenido =~ s/(?:(?!\*\*\* START OF THIS PROJECT GUTENBERG EBOOK LISBETH LONGFROCK \*\*\*).)*\*\*\* START OF THIS PROJECT GUTENBERG EBOOK LISBETH LONGFROCK \*\*\*//gs;
   $contenido =~ s/\*\*\* START: FULL LICENSE \*\*\*.*//gs;
   while ($contenido =~ /([^\.]+)/g)
   {
	   $valor = $1;
       $valor =~ s/\n//g;
	   $salida.= "$valor\."."\n";
   }
   $salida =~ s/(Mr\.)\s+/$1 /g;
   $salida =~ s/[\[\]\_\*\+]+//g;
   $salida =~ s/^[^\w]+//gm;
   
   @oraciones = split(/\n/,$salida);
   &writeFile('pretexto.txt', $salida);
   $salida="";
   #llenar datos de entrenamiento
   print "\n".@oraciones;
   
   for(my $i=0;$i<@oraciones;$i++)
   {
   my $contador=0;
   my $cverbosp=0;
   my $cverbosN=0;
   my $cAdjPos=0;
   my $cAdjNeg=0;
   my $hold=$oraciones[$i];

   #Sustantivos
	 
	if($hold=~ /$sustantivo/g)
	 {
		
		 $arff.='yes,';
	 }
	 else
	 {
		$arff.='no,';
	 }

    #Prepociciones
	 
	if($hold=~ /$preposicion/g)
	 {
		
		 $arff.='yes,';
	 }
	 else
	 {
		$arff.='no,';
	 }
   #Conjunciones Coordinadas
	 
	if($hold=~ /$coorConjun/g)
	 {
		
		 $arff.='yes,';
	 }
	 else
	 {
		$arff.='no,';
	 }
   #Conjunciones Subordinas
	 
	if($hold=~ /$subConjun/g)
	 {
		
		 $arff.='yes,';
	 }
	 else
	 {
		$arff.='no,';
	 }
   #Advervios COnjuntivos
	 
	if($hold=~ /$adConjun/g)
	 {
		
		 $arff.='yes,';
	 }
	 else
	 {
		$arff.='no,';
	 }
#Conteo verbos Positivos
	 while ($hold=~ /$verbosP/g)
	 {
	    $cverbosp++;
	 }
	    $arff.=$cverbosp.",";
 #Conteo verbos negativos
	 while ($hold=~/$verbosN/g)
	 {
	    $cverbosN++;
	 }
	 $arff.= $cverbosN.",";
		
#Adjetivos Positivos
	 while ($hold=~ /$adjetivosP/g)
	 {
	 
	    $cAdjPos++;
	 }
	    $arff.=$cAdjPos.",";
	 
	#adjetivo Negativo
	  while ($hold=~ /$adjetivosN/g)
	 {
	    $cAdjNeg++;
	 }
	    $arff.=$cAdjNeg.",";
	  
    #palabras
    while($hold =~ /([A-z]+)/g)
	{
	  $contador ++;
	}
	 $arff.=$contador.",";
	#puntiacion
	
     if($hold=~ /[\.|\,|\;|\!|\"]+/g)
	  {
	     
	     $arff.='yes,';	
	 
	  }
	  else
	  {
		$arff.='no,';
	  } 	 
     
     $arff.="\? "; 
	 $arff.="\n";
	 #$arff.= $oraciones[$i]."\n";
   }
   $arff =~ s/no,no,no,no,no,0,0,0,0,[0-9]+,[A-z]+,//g;
   $arff =~ s/^\?//gm;
   
    &writeFile($fileName, $arff);
  
}

sub trim{
	my ($str) = @_;
	
	$str =~ s/^ *| *$//g;
	return $str;
}

#When $str is filled, the function returns the full tag
#empty otherwise.
sub printOrNot{
  my ($openTag, $str ,$closeTag) = @_;

  if ($str !~ /^$/){
    $str = $openTag.$str.$closeTag;
  }

  return $str;
}

#Returns the string if defined, empty otherwise.
sub imprime{
	my ($str) = @_;
	
	if (!defined $str){
	  $str="";
	}
	return $str;
}

#Receives text between pairs of font tags
#Produces one string without html tags.
sub removeFontTags{
   my ($str) = @_;

   $str =~ s/\s*<font[^>]*>|<\/font>\s*/ /g;
   $str =~ s/ {2,}/ /g;
   return trim($str);
}


sub storeNewFile{
  my ($fileName, $fileContent) = @_;
  my $directoryName = "limpio";

  if ( -d "$directoryName") {
    print "Directory found \"$directoryName/$fileName\"\n";
  }
  else {
    print "Directory \"$directoryName\" was not found, but it has just been created.\n";
    mkdir("$directoryName");
  }

  #Removing directory name from the inicial input.
  $fileName =  substr($fileName, index ($fileName, "/")+1, (length ($fileName)-index ($fileName, "/")+1));
  &writeFile("$directoryName\\$fileName", $fileContent);
}

#Creates a new file.
#Deletes all content of old file, if existed.
sub writeFile
{
  my($fileName, $content) = @_;#
  #writing content into a file.
  #open FILE, ">$fileName";
  open(FILE, ">:utf8",$fileName) or die "Can't read file \"$fileName\" [$!]\n";
  print FILE $content;
  close (FILE);
}

sub readFiles{
	my ($folder)=@_;
	my @files=<$folder/*>;
	return @files;
}

sub openFile{
	my ($fileName) = @_;
	local $/;#read full file instead of only one line.
	open(FILE, "<:utf8",$fileName) or die "Can't read file \"$fileName\" [$!]\n";
	my $fileContent = <FILE>;
	close (FILE);

	return $fileContent;
}