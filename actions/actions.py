from typing import Any, Text, Dict, List
from rasa_sdk import Action, Tracker
from rasa_sdk.executor import CollectingDispatcher
from rasa_sdk.events import SlotSet   # importante para devolver slots

class ActionRedirigirReporte(Action):

    def name(self) -> Text:
        return "action_redirigir_reporte"

    async def run(
        self,
        dispatcher: CollectingDispatcher,
        tracker: Tracker,
        domain: Dict[Text, Any]
    ) -> List[Dict[Text, Any]]:

        tipo = tracker.latest_message.get('text')

        dispatcher.utter_message(
            text=f"¡Genial! Te llevaré al módulo de reportes para '{tipo}'. "
                 "Mientras tanto, puedo darte algunos consejos de prevención."
        )

        # Devolver el slot correctamente con SlotSet
        return [SlotSet("tipo_incidente", tipo)]
