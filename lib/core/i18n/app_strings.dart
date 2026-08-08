enum AppLanguage { english, hindi }

class AppStrings {
  final AppLanguage language;

  const AppStrings(this.language);

  bool get isHindi => language == AppLanguage.hindi;

  // App Title & Headers
  String get appTitle => isHindi ? 'खाता (Khata) - रजिस्टर' : 'Khata - Attendance Register';
  String get musterAugust => isHindi ? 'मस्टर · अगस्त २०२६' : 'MUSTER · AUGUST 2026';
  String get todaysRegister => isHindi ? 'आज का रजिस्टर' : "Today's Register";
  String get chooseLanguage => isHindi ? 'अपनी भाषा चुनें' : 'Choose Your Language';
  String get chooseLangSub => isHindi
      ? 'आप इसे बाद में भी कभी भी बदल सकते हैं'
      : 'Select language for the khata register (You can change this anytime)';

  // Navigation Drawer Strings
  String get drawerTitle => isHindi ? 'खता रजिस्टर मेनू' : 'Muster Book Menu';
  String get drawerSub => isHindi ? 'पारंपरिक भारतीय रजिस्टर' : 'Traditional Ledger System';
  String get selectLanguage => isHindi ? 'भाषा (Language)' : 'App Language';
  String get feedbackAndWishlist => isHindi ? 'सुझाव व फीडबैक' : 'Feedback & Suggestions';
  String get clearSampleData => isHindi ? 'नमूना (Dummy) डाटा साफ़ करें' : 'Clear Sample Data';
  String get sampleDataCleared => isHindi ? 'नमूना डाटा साफ़ कर दिया गया है' : 'Sample data cleared successfully';
  String get appVersion => isHindi ? 'संस्करण १.०.०' : 'Version 1.0.0';

  // Ribbon Stats
  String get workers => isHindi ? 'मज़दूर' : 'Workers';
  String get present => isHindi ? 'उपस्थित' : 'Present';
  String get earned => isHindi ? 'कुल कमाई' : 'Earned';
  String get totalDue => isHindi ? 'कुल बाकी' : 'Total Due';

  // Search & Empty State
  String get searchHint => isHindi ? 'मज़दूर का नाम या काम खोजें...' : 'Search worker or role...';
  String get addEmployee => isHindi ? '+ नया मज़दूर जोड़ें' : '+ Add employee';
  String get dueTagPrefix => isHindi ? 'बाकी' : 'due';
  String get noWorkersYet => isHindi ? 'अभी कोई मज़दूर नहीं जोड़ा गया है' : 'No workers added yet';
  String get noWorkersSub => isHindi
      ? 'नीचे बटन पर क्लिक करके पहला मज़दूर जोड़ें'
      : 'Click the button below to add your first worker';

  // Stamp labels
  String get presentLabel => isHindi ? 'उपस्थित (P)' : 'Present';
  String get halfDayLabel => isHindi ? 'आधा दिन (H)' : 'Half Day';
  String get absentLabel => isHindi ? 'अनुपस्थित (A)' : 'Absent';
  String get notMarked => isHindi ? 'हाजिरी नहीं लगी' : 'Not Marked';

  // Stat Pills
  String get fullDays => isHindi ? 'पूरे दिन' : 'Full days';
  String get halfDays => isHindi ? 'आधा दिन' : 'Half days';
  String get absent => isHindi ? 'अनुपस्थित' : 'Absent';

  // Ledger Card
  String get paid => isHindi ? 'भुगतान किया' : 'Paid';
  String get advance => isHindi ? 'एडवांस दिया' : 'Advance';
  String get balanceDue => isHindi ? 'बाकी राशि (देना है)' : 'Balance due';
  String get recordPayment => isHindi ? 'भुगतान दर्ज करें' : 'Record Payment';
  String get giveAdvance => isHindi ? 'एडवांस दें' : 'Give Advance';

  // Calendar & Work Log & Share
  String get augustAttendance => isHindi ? 'अगस्त महीने की हाजिरी' : 'AUGUST ATTENDANCE';
  String get workLog => isHindi ? 'दैनिक कार्य विवरण' : 'WORK LOG';
  String get noWorkNotes => isHindi ? 'कोई कार्य टिप्पणी नहीं लिखी गई' : 'No work notes recorded yet.';
  String get addDailyWorkNote => isHindi ? 'आज का काम लिखें...' : 'Add daily work note...';
  String get addBtn => isHindi ? '+ जोड़ें' : '+ Add';
  String get shareWhatsapp => isHindi ? 'व्हाट्सएप रसीद भेजें' : 'Share WhatsApp Slip';

  // Add Worker Modal (Full Hindi & English)
  String get addNewWorker => isHindi ? 'नया मज़दूर जोड़ें' : 'Add New Worker';
  String get workerName => isHindi ? 'मज़दूर का नाम' : 'Worker Name';
  String get workerNameHint => isHindi ? 'जैसे: रमेश यादव' : 'e.g. Ramesh Yadav';
  String get workerNameError => isHindi ? 'कृपया नाम दर्ज करें' : 'Please enter name';

  String get roleOccupation => isHindi ? 'काम / पद' : 'Role / Occupation';
  String get roleOccupationHint => isHindi ? 'जैसे: मिस्त्री, हेल्पर, इलेक्ट्रीशियन' : 'e.g. Site Mason, Helper, Electrician';
  String get roleOccupationError => isHindi ? 'कृपया पद दर्ज करें' : 'Please enter role';

  String get dailyRate => isHindi ? 'दैनिक दिहाड़ी (₹/दिन)' : 'Daily Rate (₹/day)';
  String get dailyRateHint => isHindi ? '६५०' : '650';
  String get dailyRateError => isHindi ? 'दिहाड़ी दर्ज करें' : 'Enter rate';

  String get initialAdvance => isHindi ? 'शुरुआती एडवांस (₹)' : 'Initial Advance (₹)';
  String get initialAdvanceHint => isHindi ? '०' : '0';

  String get cancel => isHindi ? 'रद्द करें' : 'Cancel';
  String get saveEmployee => isHindi ? 'मज़दूर सुरक्षित करें' : 'Save Employee';

  // Record Payment Modal
  String get recordSalaryPayment => isHindi ? 'वेतन भुगतान दर्ज करें' : 'Record Salary Payment';
  String get giveCashAdvance => isHindi ? 'कैश एडवांस दें' : 'Give Cash Advance';
  String get savePayment => isHindi ? 'भुगतान सेव करें' : 'Save Payment';
  String get saveAdvance => isHindi ? 'एडवांस सेव करें' : 'Save Advance';
  String get amountInRs => isHindi ? 'राशि (₹)' : 'Amount (₹)';
  String get workerLabel => isHindi ? 'मज़दूर' : 'Worker';

  // Feedback & Wishlist
  String get appFeedback => isHindi ? 'ऐप सुझाव व फीडबैक' : 'App Feedback & Wishlist';
  String get feedbackSub => isHindi
      ? 'आप इस ऐप में क्या नया फीचर चाहते हैं? हमें बताएं!'
      : 'What features would you like in future updates? Let us know!';
  String get selectTopic => isHindi ? 'विषय चुनें:' : 'Select Category:';
  String get topicCloud => isHindi ? '☁️ क्लाउड बैकअप' : '☁️ Cloud Backup';
  String get topicPdf => isHindi ? '📄 PDF रिपोर्ट' : '📄 PDF Export';
  String get topicWhatsapp => isHindi ? '💬 व्हाट्सएप रसीद' : '💬 WhatsApp Receipt';
  String get topicOther => isHindi ? '✨ अन्य सुझाव' : '✨ Other Suggestion';
  String get feedbackHint => isHindi
      ? 'अपना विचार यहाँ लिखें (e.g. व्हाट्सएप पर डायरेक्ट रसीद भेजने का बटन दें...)'
      : 'Write your suggestion here...';
  String get submitFeedback => isHindi ? 'सुझाव भेजें' : 'Submit Feedback';
  String get thankYouFeedback => isHindi ? 'धन्यवाद! आपका सुझाव दर्ज हो गया है।' : 'Thank you! Your feedback has been received.';

  String get continueText => isHindi ? 'आगे बढ़ें' : 'Continue';
}
