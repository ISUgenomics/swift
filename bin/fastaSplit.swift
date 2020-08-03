//
//  fastaSplit.swift
//
//
//  Created by Andrew J Severin on 8/3/20.
//
import Foundation

// COMMANDLINE IN/OUT and ARGUMENTS
      var stderr = StandardErrorOutputStream()
      var stdout = StandardOutputStream()
      if CommandLine.arguments.count < 3 {
          usage()
      }

// READ IN THE FASTA FILE
      let path = CommandLine.arguments[1]
      let lengthIn = Int(CommandLine.arguments[2]) ?? 1000 // default value is 1000 if Integer is not provided on the command line.


      //do {
        // Get contents of file
        let contents = try String(contentsOfFile: path, encoding: .utf8)
        print("done reading")
        print(contents.components(separatedBy: "\n").count)
      //
      //} catch
      //{ print("oops! Something went wrong: \(error)")}


      // create a struct to hold the fasta sequences with functions for GC content and def and seq variables
      struct fasta {

          // variables for the definition and Sequence lines of the fasta and nucleotide count
          var def: String
          var seq: String
          var length = 0  // Function to get the length of the sequence
      }


      var fastas: [fasta] = [fasta]()  //create an empty array of fasta structs to hold the sequences from the FASTA file
      var fastaNum = -1  // store the fasta struct number, this way we can append all the sequence to the seq variable corresponding to the current fastaNum struct.


      let lines = contents.components(separatedBy: "\n")


      //lines.forEach { line in
      for line in lines {

          if line.starts(with: ">") {
              //create an empty fasta struct
               var createfasta = fasta(def: "", seq: "")
              // add the defline into the struct for a scaffold
              fastaNum += 1
              createfasta.def = line.trimmingCharacters(in: .whitespacesAndNewlines)
              fastas.append(createfasta)
            //  print(createfasta.def)
          } else if line.starts(with: "#"){
              // print the lines that are comments
              print(line)
          } else {
              fastas[fastaNum].seq += line.trimmingCharacters(in: .whitespacesAndNewlines)
              fastas[fastaNum].length += line.trimmingCharacters(in: .whitespacesAndNewlines).count
          }
      }

      //print(fastas[0].seq.split(length: 1000))

// LOOP THROUGH ALL THE FASTA RECORDS and SPLIT THEM to SIZE LENGTHIN
      for fasta in fastas {
      fasta.splitFasta(length: lengthIn)
      }


//FUNCTIONS

func usage() {
   let usageStr = """
      fastaSplit InputFastaFile LengthToSplitAllRecords

      This program will take a fasta file as input and a length to split each record of the the fasta file
      into new records of specified length.  If the length specified is longer than the length of the record
      the original record is returned.  If the the record doesn't split evenly into the length, the final
      record will be the remainder of the sequence.

"""
    print(usageStr, to: &stderr)
    exit(0)
}

//EXTENSIONS
      // Used this extenstion as an example for fasta split
      //extension String {
      //    func split(length: Int) -> [String] {
      //        var startIndex = self.startIndex
      //        var results = [Substring]()
      //
      //        while startIndex < self.endIndex {
      //            let endIndex = self.index(startIndex, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
      //            results.append(self[startIndex..<endIndex])
      //            startIndex = endIndex
      //        }
      //
      //        return results.map { String($0) }
      //    }
      //}

      extension fasta {

          func splitFasta(length: Int) {
              var start = 1
              var end = start + length - 1
              if end > self.seq.count {
                  end = self.seq.count
              }
              var startIndex = self.seq.startIndex
              //var results = [Substring]()
              while startIndex < self.seq.endIndex {
                  let endIndex = self.seq.index(startIndex, offsetBy: length, limitedBy: self.seq.endIndex) ?? self.seq.endIndex
                  print(self.def, String(start) + ".." + String(end))
                  print(self.seq[startIndex..<endIndex])
                  startIndex = endIndex
                  start = start + length
                  end = start + length - 1
                  if end > self.length {
                      end = self.length
                  }
              }


          }

      }

// CLASSES
            // classes to write to stderr and stdout

            final class StandardErrorOutputStream: TextOutputStream {
                func write(_ string: String) {
                    FileHandle.standardError.write(Data(string.utf8))
                }
            }
            final class StandardOutputStream: TextOutputStream {
                func write(_ string: String) {
                    FileHandle.standardOutput.write(Data(string.utf8))
                }
            }
