import dotenv
from langchain_openai import ChatOpenAI
from langchain.schema.messages import HumanMessage, SystemMessage

dotenv.load_dotenv()

chat_model = ChatOpenAI(model="gpt-3.5-turbo-0125", temperature=0)
messages = [
    SystemMessage(
         content="""You're an assistant knowledgeable about
         healthcare. Only answer healthcare-related questions."""
     ),
    HumanMessage(content="What is Medicaid managed care?"),
 ]
chat_model.invoke(messages)