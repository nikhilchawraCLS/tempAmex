public class Journey_Optimizer_Wrapper {

	public Journeyoptimizerresponsesummary journeyoptimizerresponsesummary;

	public class Journeyoptimizerresponsesummary {
		public String application_no;
		public Decision decision;
		public Offer_details offer_details;
		public Customer_data customer_data;
		public String reg_o;
	}

	public class Decision_reasons {
		public String decision_reason1;
		public String decision_reason2;
		public String decision_reason3;
		public String decision_reason4;
		public String decision_reason5;
	}

	public class Commercial_credit_score_details {
		public String source;
		public String score;
		public String reasonCd1;
		public String reasonCd2;
		public String reasonCd3;
		public String reasonCd4;
		public String date1;
	}

	public class Customer_data {
		public Commercial_credit_score_details commercial_credit_score_details;
		public Commercial_credit_score_details fam_score_details;
		public Commercial_credit_score_details financial_stress_score_details;
		public Fico_score_details fico_score_details;
	}

	public class Offers {
		public String term;
		public String liability;
		public String repayment_type;
		public String repyament_frequency;
		public String max_amount;
		public String rate;
		public String max_hbr;
	}

	public class Fico_score_details {
		public String source;
		public String score;
		public String reasonCd1;
		public String reasonCd2;
		public String reasonCd3;
		public String reasonCd4;
		public String reasonCd5;
		public String rate;
	}

	public class Decision {
		public String journey_stage;
		public String decision_code;
		public Decision_reasons decision_reasons;
	}

	public class Offer_validity {
		public String offer_valid_till;
		public String date_format;
	}

	public class Offer_details {
		public String currency_code;
		public String term_duration;
		public Offer_validity offer_validity;
		public List<Offers> offers;
	}

	
	
}