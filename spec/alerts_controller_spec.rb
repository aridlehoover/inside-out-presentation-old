if ENV['AC']
  require_relative '../application_centric/app/controllers/alerts_controller'
else
  require_relative '../framework_centric/app/controllers/alerts_controller'
end

describe AlertsController do
  subject(:controller) { described_class.new(params) }

  let(:params) { { address: address } }
  let(:address) { 'address' }

  describe '#import' do
    subject(:import) { controller.import }

    before do
      allow(controller).to receive(:render)
    end

    context 'when the address is unsupported' do
      let(:address) { 'unknown'}
      let(:feed_items) { nil }

      before { import }

      it 'renders the new page with a notice' do
        expect(controller).to have_received(:render)
          .with(:new, notice: a_kind_of(String))
      end
    end

    context 'and the address is supported' do
      let(:address) { 'nws.xml' }

      context 'and the feed is the NWS RSS feed' do
        let(:address) { 'nws.xml' }
        let(:feed_items) { [] }

        before do
          allow(RSS).to receive(:read).and_return(feed_items)
        end

        it 'reads the feed' do
          import

          expect(RSS).to have_received(:read).with(address)
        end

        context 'and the feed has no content' do
          let(:feed_items) { [] }

          before { import }

          it 'renders the new page with a notice' do
            expect(controller).to have_received(:render)
              .with(:new, notice: a_kind_of(String))
          end
        end

        context 'and the feed has content' do
          let(:feed_items) { [feed_item] }
          let(:feed_item) do
            instance_double(
              'feed_item',
              id: 'id',
              title: 'title',
              summary: 'summary',
              published: 'published',
              updated: 'updated',
              cap_effective: 'cap_effective',
              cap_expires: 'cap_expires'
            )
          end
          let(:alert) { instance_double(Alert, active?: active) }
          let(:active) { true }
          let(:subscribers) { [] }

          before do
            allow(Alert).to receive(:create).and_return(alert)
            allow(Subscriber).to receive(:find_all).and_return(subscribers)
            allow(controller).to receive(:redirect_to)
            allow(SMS).to receive(:deliver)

            import
          end

          it 'creates an alert for each item in the feed' do
            expect(Alert).to have_received(:create).with(
              uuid: 'id',
              title: 'title',
              description: 'summary',
              published_at: 'published',
              updated_at: 'updated',
              effective_at: 'cap_effective',
              expires_at: 'cap_expires'
            )
          end

          it 'redirects to the alerts page with a notice' do
            expect(controller).to have_received(:redirect_to)
              .with('/alerts', notice: a_kind_of(String))
          end

          context 'and there are subscribers' do
            let(:subscribers) { [subscriber] }
            let(:subscriber) { instance_double(Subscriber) }

            it 'notifies subscribers of active alerts via SMS' do
              expect(SMS).to have_received(:deliver)
                .with(subscriber, [alert])
            end
          end
        end
      end

      context 'and the feed is the NOAA RSS feed' do
        let(:address) { 'noaa.xml' }
        let(:feed_items) { [] }

        before do
          allow(RSS).to receive(:read).and_return(feed_items)
        end

        it 'reads the feed' do
          import

          expect(RSS).to have_received(:read).with(address)
        end

        context 'and the feed has no content' do
          let(:feed_items) { [] }

          before do
            allow(controller).to receive(:redirect_to)

            import
          end

          it 'renders the new page with a notice' do
            expect(controller).to have_received(:render)
              .with(:new, notice: a_kind_of(String))
          end
        end

        context 'and the feed has content' do
          let(:feed_items) { [feed_item] }
          let(:feed_item) do
            instance_double(
              'feed_item',
              id: 'id',
              title: 'title',
              description: 'description',
              pub_date: '2020-01-01 00:00:00 -0800',
              last_update: 'last_update',
            )
          end
          let(:alert) { instance_double(Alert, active?: active) }
          let(:active) { true }
          let(:subscribers) { [subscriber] }
          let(:subscriber) { instance_double(Subscriber) }

          before do
            allow(Alert).to receive(:create).and_return(alert)
            allow(Subscriber).to receive(:find_all).and_return(subscribers)
            allow(controller).to receive(:redirect_to)
            allow(SMS).to receive(:deliver)

            import
          end

          it 'creates an alert for each item in the feed' do
            expect(Alert).to have_received(:create).with(
              uuid: 'id',
              title: 'title',
              description: 'description',
              published_at: '2020-01-01 00:00:00 -0800',
              updated_at: 'last_update',
              effective_at: '2020-01-01 00:00:00 -0800',
              expires_at: '2020-01-01 06:00:00 -0800'
            )
          end

          it 'redirects to the alerts page with a notice' do
            expect(controller).to have_received(:redirect_to)
              .with('/alerts', notice: a_kind_of(String))
          end

          context 'and there are subscribers' do
            let(:subscribers) { [subscriber] }
            let(:subscriber) { instance_double(Subscriber) }

            it 'notifies subscribers of active alerts via SMS' do
              expect(SMS).to have_received(:deliver)
                .with(subscriber, [alert])
            end
          end
        end
      end

      context 'and the feed is the Tornado Weather Alerts twitter account' do
        let(:address) { 'twitter.com/TornadoWeather' }
        let(:feed_items) { [] }

        before do
          allow(Twitter).to receive(:fetch).and_return(feed_items)
        end

        it 'fetches the feed' do
          import

          expect(Twitter).to have_received(:fetch).with(address)
        end

        context 'and the feed has no content' do
          let(:feed_items) { [] }

          before do
            allow(controller).to receive(:redirect_to)

            import
          end

          it 'renders the new page with a notice' do
            expect(controller).to have_received(:render)
              .with(:new, notice: a_kind_of(String))
          end
        end

        context 'and the feed has content' do
          let(:feed_items) { [feed_item] }
          let(:feed_item) do
            instance_double(
              'feed_item',
              id: 'tweet id',
              body: 'title.description',
              date_time: '2020-01-01 00:00:00 -0800',
            )
          end
          let(:alert) { instance_double(Alert, active?: active) }
          let(:active) { true }
          let(:subscribers) { [subscriber] }
          let(:subscriber) { instance_double(Subscriber) }

          before do
            allow(Alert).to receive(:create).and_return(alert)
            allow(Subscriber).to receive(:find_all).and_return(subscribers)
            allow(controller).to receive(:redirect_to)
            allow(SMS).to receive(:deliver)

            import
          end

          it 'creates an alert for each item in the feed' do
            expect(Alert).to have_received(:create).with(
              uuid: 'tweet id',
              title: 'title',
              description: 'description',
              published_at: '2020-01-01 00:00:00 -0800',
              updated_at: '2020-01-01 00:00:00 -0800',
              effective_at: '2020-01-01 00:00:00 -0800',
              expires_at: '2020-01-01 01:00:00 -0800'
            )
          end

          it 'redirects to the alerts page with a notice' do
            expect(controller).to have_received(:redirect_to)
              .with('/alerts', notice: a_kind_of(String))
          end

          context 'and there are subscribers' do
            let(:subscribers) { [subscriber] }
            let(:subscriber) { instance_double(Subscriber) }

            it 'notifies subscribers of active alerts via SMS' do
              expect(SMS).to have_received(:deliver)
                .with(subscriber, [alert])
            end
          end
        end
      end
    end
  end
end
