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

    context 'when the address is supported' do
      let(:address) { 'nws.xml'}
      let(:feed_items) { nil }

      before do
        allow(RSS).to receive(:read).and_return(feed_items)
      end

      it 'reads the feed' do
        import

        expect(RSS).to have_received(:read).with(address)
      end

      context 'and the feed is nil' do
        let(:feed_items) { nil }

        before { import }

        it 'renders the new page with a notice' do
          expect(controller).to have_received(:render)
            .with(:new, notice: a_kind_of(String))
        end
      end

      context 'and the feed is empty' do
        let(:feed_items) { [] }

        before { import }

        it 'renders the new page with a notice' do
          expect(controller).to have_received(:render)
            .with(:new, notice: a_kind_of(String))
        end
      end

      context 'and the feed is not empty' do
        let(:feed_items) { [feed_item] }

        context 'and the feed is the NWS RSS feed' do
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

          before do
            allow(Alert).to receive(:create)
            allow(controller).to receive(:redirect_to)

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
        end

        xcontext 'and the feed is the NOAA RSS feed' do
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

          before do
            allow(Alert).to receive(:create)
            allow(controller).to receive(:redirect_to)

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
        end
      end
    end
  end
end
