//
//  QuestionViewController.swift
//  PersonalityQuiz
//
//  Created by Stepan Baranov on 26.10.2023.
//

import UIKit

class QuestionViewController: UIViewController {
    
    @IBOutlet var questionLabel: UILabel!
    
    @IBOutlet var singleStackView: UIStackView!
    @IBOutlet var singleButton1: UIButton!
    @IBOutlet var singleButton2: UIButton!
    @IBOutlet var singleButton3: UIButton!
    @IBOutlet var singleButton4: UIButton!
    
    @IBOutlet var multipleStackView: UIStackView!
    @IBOutlet var multiLabel1: UILabel!
    @IBOutlet var multiLabel2: UILabel!
    @IBOutlet var multiLabel3: UILabel!
    @IBOutlet var multiLabel4: UILabel!
    @IBOutlet var multiSwitch1: UISwitch!
    @IBOutlet var multiSwitch2: UISwitch!
    @IBOutlet var multiSwitch3: UISwitch!
    @IBOutlet var multiSwitch4: UISwitch!
    
    @IBOutlet var rangedStackView: UIStackView!
    @IBOutlet var rangeLabel1: UILabel!
    @IBOutlet var rangeLabel2: UILabel!
    @IBOutlet var rangedSlider: UISlider!
    
    @IBOutlet var questionProgressView: UIProgressView!
    
    var questions: [Question] = [
      Question(
        text: "Which food do you like the most?",
        type: .single,
        answers: [
          Answer(text: "Steak", type: .dog),
          Answer(text: "Fish", type: .cat),
          Answer(text: "Carrots", type: .rabbit),
          Answer(text: "Corn", type: .turtle)
        ]
      ),
     
      Question(
        text: "Which activities do you enjoy?",
        type: .multiple,
        answers: [
          Answer(text: "Swimming", type: .turtle),
          Answer(text: "Sleeping", type: .cat),
          Answer(text: "Cuddling", type: .rabbit),
          Answer(text: "Eating", type: .dog)
        ]
      ),
     
      Question(
        text: "How much do you enjoy car rides?",
        type: .ranged,
        answers: [
          Answer(text: "I dislike them", type: .cat),
          Answer(text: "I get a little nervous", type: .rabbit),
          Answer(text: "I barely notice them", type: .turtle),
          Answer(text: "I love them", type: .dog)
        ]
      )
    ]
    var questionIndex = 0
    var answersChosen: [Answer] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    @IBAction func singleAnswerButtonPressed(_ sender: UIButton) {
        let currentAnswer = questions[questionIndex].answers
        switch sender {
        case singleButton1:
            answersChosen.append(currentAnswer[0])
        case singleButton2:
            answersChosen.append(currentAnswer[1])
        case singleButton3:
            answersChosen.append(currentAnswer[2])
        case singleButton4:
            answersChosen.append(currentAnswer[3])
        default:
            break
        }
        
        nextQuestion()
    }
    
    @IBAction func multipleAnswerButtonPressed() {
        let currentAnswer = questions[questionIndex].answers
        if multiSwitch1.isOn {
            answersChosen.append(currentAnswer[0])
        }
        
        if multiSwitch2.isOn {
            answersChosen.append(currentAnswer[1])
        }
        
        if multiSwitch3.isOn {
            answersChosen.append(currentAnswer[2])
        }
        
        if multiSwitch4.isOn {
            answersChosen.append(currentAnswer[3])
        }
        
        nextQuestion()
    }
    
    @IBAction func rangedAnswerButtonPressed() {
        let currentAnswer = questions[questionIndex].answers
        let index = Int(round(rangedSlider.value * Float(currentAnswer.count - 1)))
        answersChosen.append(currentAnswer[index])
        
        nextQuestion()
    }
    
    @IBSegueAction func showResults(_ coder: NSCoder) -> ResultsViewController? {
        return ResultsViewController(coder: coder, responses: answersChosen)
    }
    
    func nextQuestion() {
        questionIndex += 1
        
        if questionIndex < questions.count {
            updateUI()
        } else {
            performSegue(withIdentifier: "Results", sender: nil)
        }
    }
    
    func updateUI() {
        singleStackView.isHidden = true
        multipleStackView.isHidden = true
        rangedStackView.isHidden = true
        
        let currentQuestion = questions[questionIndex]
        let currentAnswer = currentQuestion.answers
        let totalProgress = Float(questionIndex) / Float(questions.count)
        
        navigationItem.title = "Question #\(questionIndex+1)"
        questionLabel.text = currentQuestion.text
        questionProgressView.setProgress(totalProgress, animated: true)
        
        switch currentQuestion.type {
        case .single:
            updateSingleStack(using: currentAnswer)
        case .multiple:
            updateMultipleStack(using: currentAnswer)
        case .ranged:
            updateRangedStack(using: currentAnswer)
        }
    }
    
    func updateSingleStack(using answers: [Answer]) {
        singleStackView.isHidden = false
        singleButton1.setTitle(answers[0].text, for: .normal)
        singleButton2.setTitle(answers[1].text, for: .normal)
        singleButton3.setTitle(answers[2].text, for: .normal)
        singleButton4.setTitle(answers[3].text, for: .normal)
    }
    
    func updateMultipleStack(using answers: [Answer]) {
        multipleStackView.isHidden = false
        multiSwitch1.isOn = false
        multiSwitch2.isOn = false
        multiSwitch3.isOn = false
        multiSwitch4.isOn = false
        multiLabel1.text = answers[0].text
        multiLabel2.text = answers[1].text
        multiLabel3.text = answers[2].text
        multiLabel4.text = answers[3].text
    }
    
    func updateRangedStack(using answers: [Answer]) {
        rangedStackView.isHidden = false
        rangedSlider.setValue(0.5, animated: false)
        rangeLabel1.text = answers.first?.text
        rangeLabel2.text = answers.last?.text
    }
}
