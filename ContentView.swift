import SwiftUI

struct ContentView: View {
    @State private var showTimer = false
    @State private var showHomepage = false
    @State private var showFlashcards = false
    @State private var showPlanner = false 
    @State private var showChecklist = false
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                NavigationLink(destination: Homepage(), isActive: $showHomepage) {
                    Button("Homepage") {
                        showHomepage = true
                    }
                    .buttonStyle(BorderedButtonStyle())
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(100)
                    .padding()
                }
                
                NavigationLink(destination: ChecklistView(), isActive: $showChecklist) {
                    Button("Checklist") {
                        showChecklist = true
                    }
                    .buttonStyle(BorderedButtonStyle())
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(100)
                    .padding()
                }
                
                NavigationLink(destination: PlannerView(), isActive: $showPlanner){
                    Button("Planner"){
                        showPlanner = true
                    }
                    .buttonStyle(BorderedButtonStyle())
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(100)
                    .padding()
                }
                NavigationLink(destination: TimerView(), isActive: $showTimer) {
                    Button("Pomodoro Timer") {
                        showTimer = true
                    }
                    
                    .buttonStyle(BorderedButtonStyle())
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(100)
                    .padding()
                }
                
                NavigationLink(destination: FlashcardsView(), isActive: $showFlashcards) {
                    Button("Flashcards") {
                        showFlashcards = true
                    }
                    
                    .buttonStyle(BorderedButtonStyle())
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(100)
                    .padding()
                }
                
                
            }
            .navigationBarTitle("Menu")
        }
    }
}

struct TimerView: View {
    @State private var minutes = ""
    @State private var seconds = ""
    @State private var timeRemaining = 0
    @State private var timer: Timer? = nil
    
    var body: some View {
        VStack {
            HStack {
                TextField("Minutes", text: $minutes)
                    .keyboardType(.numberPad)
                    .padding()
                Text(":")
                TextField("Seconds", text: $seconds)
                    .keyboardType(.numberPad)
                    .padding()
            }
            Button(action: {
                timeRemaining = (Int(minutes) ?? 0) * 60 + (Int(seconds) ?? 0)
                startTimer()
            }) {
                Text("Start")
            }
            .padding()
            .disabled(timer != nil)
            
            Button(action: {
                timer?.invalidate()
                timer = nil
                timeRemaining = 0
                minutes = ""
                seconds = ""
            }) {
                Text("Stop")
            }
            .padding()
            .disabled(timer == nil)
            
            Text("\(timeRemaining / 60):\(String(format: "%02d", timeRemaining % 60))")
                .font(.system(size: 72))
        }
        .navigationBarTitle("Pomodoro Timer")
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer?.invalidate()
                timer = nil
            }
        }
    }
}

struct Homepage: View {
    @State private var quoteIndex = 0
    let quotes = [
        "The earlier you start working on something, the earlier you will see results.",
        "When you have a dream, you've got to grab it and never let go.",
        "Nothing is impossible. The word itself says 'I'm possible!'",
        "The bad news is time flies. The good news is you're the pilot.",
        "Success is not final, failure is not fatal: it is the courage to continue that counts."
    ]
    
    var body: some View {
        VStack {
            Text("Welcome to StuDino")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.green)
                .padding()
            
            Text("Here's a guide to how this app works :)")
                .bold()
                .padding()
            Text("1. Use the homepage to get your motivations back!")
                .font(.footnote)
                .foregroundColor(.secondary)
            Text("2. Decide what you plan to achieve using the Checklist page")
                .font(.footnote)
                .foregroundColor(.secondary)
            Text("3. Plan how long you wish to spend in each session using the Planner page")
                .font(.footnote)
                .foregroundColor(.secondary)
            Text("4. Start your session by timing yourself!")
                .font(.footnote)
                .foregroundColor(.secondary)
            Text("5. Use the Flashcard page to quickly jot down some key points from your study session")
                .font(.footnote)
                .foregroundColor(.secondary)
            Text("6. Repeat cycle for the next subject/task!")
                .font(.footnote)
                .foregroundColor(.secondary)
            
            
            
            Image("Dino")
                .resizable()
                .frame(width:300, height: 310)
                .padding()
            
            Text("Need motivations? Why not read a quote!")
                .font(.caption)
                .italic()
                .padding()
            
            Text(quotes[quoteIndex])
                .padding()
            
            Button(action: {
                quoteIndex = (quoteIndex + 1) % quotes.count
            }) {
                Text("Another quote")
            }
            .font(.body)
            .buttonStyle(BorderedButtonStyle())
            .foregroundColor(.white)
            .background(Color.green)
            .cornerRadius(100)
            
            Spacer()
        }
        .navigationBarTitle("Homepage")
    }
}

struct FlashcardsView: View {
    @State private var question = ""
    @State private var answer = ""
    @State private var flashcards: [(question: String, answer: String)] = []
    
    var body: some View {
        VStack {
            HStack {
                TextField("Question", text: $question)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                TextField("Answer", text: $answer)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Button(action: addFlashcard) {
                    Text("Add")
                }
                .padding()
            }
            List {
                ForEach(0..<flashcards.count, id: \.self) { index in
                    VStack(alignment: .leading) {
                        Text(self.flashcards[index].question)
                            .font(.headline)
                        Text(self.flashcards[index].answer)
                            .font(.subheadline)
                    }
                    .contextMenu {
                        Button(action: {
                            self.deleteFlashcard(at: index)
                        }) {
                            Text("Delete")
                            Image(systemName: "trash")
                        }
                    }
                }
            }
        }
        .padding()
        .navigationBarTitle("Flashcards")
    }
    
    func addFlashcard() {
        if !question.isEmpty && !answer.isEmpty {
            flashcards.append((question, answer))
            question = ""
            answer = ""
        }
    }
    
    func deleteFlashcard(at index: Int) {
        flashcards.remove(at: index)
    }
}

struct PlannerView: View{
    @State var minutes = 0.00
    var hours : Double{
        get{
            return minutes/60
        }
    }
    @State private var rest: Double = 0
    
    var body:some View{
        VStack{
            Text("Planner: ")
                .font(.largeTitle)
                .padding()
            switch minutes{
            case 0...30:
                Text("A short 15mins study session")
            case 31...60:
                Text("Perfect time to do homeworks")
            case 61...75:
                Text("Just the right amount of time for a study session")
            default:
                Text("Enjoy your study session!")
            }
            Spacer()
                .frame(height:20)
            Text("Study Session")
                .font(.title2)
                .bold()
            Slider(value:$minutes, in:0...180, step: 5){
                
            } minimumValueLabel:{
                Text("0").font(.title2)
            } maximumValueLabel:{
                Text("180").font(.title2)
            }.tint(.green)
                .padding()
            Text("\(minutes, specifier:"%.2f") minutes")
                .font(.title3)
                .padding()
            
            Text("Rest Time")
                .font(.title2)   .bold()
            Slider(value: $rest, in: 0...60, step: 1) {
                
            } minimumValueLabel: {
                Text("0").font(.title2)
            } maximumValueLabel: {
                Text("60").font(.title2)
            }
            .tint(.green)
            .padding()
            Text("\(rest, specifier:"%.2f") minutes")
                .font(.title3)
        }
        .navigationBarTitle("Planner")
    }
}

struct ChecklistView: View{
    @State private var tasks: [String] = []
    @State private var completed: [Bool] = []
    
    @State private var newTask: String = ""
    
    var body: some View {
        VStack {
            HStack {
                TextField("Enter a new task", text: $newTask)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Add Task", action: addTask)
                    .buttonStyle(BorderlessButtonStyle())
            }
            .padding()
            
            List {
                ForEach(tasks.indices, id: \.self) { index in
                    Toggle(tasks[index], isOn: $completed[index])
                        .toggleStyle(CheckboxToggleStyle())
                        .padding(.vertical, 5)
                }
            }
            .padding() 
            .navigationBarTitle("Checklist")
        }
        
    }
    
    func addTask() {
        guard !newTask.isEmpty else { return }
        tasks.append(newTask)
        completed.append(false)
        newTask = ""
    }
}

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }) {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                configuration.label
            }
            .foregroundColor(configuration.isOn ? .green : .primary)
            .padding(.vertical, 5)
        }
        .buttonStyle(BorderlessButtonStyle())
    }
    
}

